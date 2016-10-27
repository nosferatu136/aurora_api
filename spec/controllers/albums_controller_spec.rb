require 'rails_helper'

describe AlbumsController do
  include AuthHelper

  before { http_login }


  describe 'create' do
    let(:artist) { Factory(:artist, name: 'Guns n Roses') }
    let(:album_params) do
      {
        name: 'Appetite for destruction',
        artist_id: artist.id,
        art_id: 123,
        released_at: (Date.today - 15.years)
      }
    end

    let(:json) { JSON.parse(response.body) }

    def do_request(params = {})
      post :create, params
    end

    context 'when params are correct' do
      it 'creates a new album' do
        expect { do_request(album_params) }.to change { Album.count }.by(1)
        expect(response).to be_success
        expect(json['errors']).to be_empty
      end
    end

    context 'when params are not correct' do
      it 'does not create a new album' do
        album_params.delete(:name)
        expect { do_request(album_params) }.not_to change { Album.count }
        expect(response).not_to be_success
        expect(json['errors']).to include 'Name can\'t be blank'
      end
    end
  end

  describe 'update' do
    let!(:album) { Factory(:album) }
    let(:new_name) { 'The Spaghetti Incident' }
    let(:album_params) { { id: album.id, name: new_name } }

    def do_request(params = {})
      put :update, params
    end

    context 'when album exists' do
      it 'updates the given album' do
        expect { do_request(album_params) }.not_to change { Album.count }
        expect(response).to be_success
        expect(album.reload.name).to eq new_name
      end
    end

    context 'when album does not exist' do
      it 'returns the correct status' do
        album_params[:id] = album.id + 1
        expect { do_request(album_params) }.not_to change { Album.count }
        expect(response.status).to eq 404
      end
    end
  end

  describe 'delete' do
    def do_request(params = {})
      delete :destroy, params
    end

    context 'when album exists' do
      it 'returns success' do
        album = Factory(:album)
        do_request(id: album.id)
        expect(response).to be_success
      end
    end

    context 'when album does not exist' do
      it 'returns 404' do
        do_request(id: 1)
        expect(response.status).to eq 404
      end
    end

    context 'when album fails to be deleted' do
      it 'returns 422' do
        album = Factory.stub(:album)
        allow(Album).to receive(:find_by_id) { album }
        allow(album).to receive(:destroy) { false }
        do_request(id: album.id)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'add_songs' do
    def do_request(params)
      post :add_songs, params
    end

    it 'instantiates a song processor to perform the action' do
      album = Factory.stub(:album)
      params = {
        'album_id' => album.id.to_s,
        'song_ids' => ['1', '2', '3']
      }
      processor = double('AlbumSongProcessor', album: album, status: :ok, errors: [])
      allow(processor).to receive(:process) { processor }
      expect(AlbumsController::AlbumSongProcessor).to receive(:new).with(params, :add).and_return(processor)
      do_request(params)
    end
  end

  describe 'remove_songs' do
    def do_request(params)
      post :remove_songs, params
    end

    it 'instantiates a song processor to perform the action' do
      album = Factory.stub(:album)
      params = {
        'album_id' => album.id.to_s,
        'song_ids' => ['1', '2', '3']
      }
      processor = double('AlbumSongProcessor', album: album, status: :ok, errors: [])
      allow(processor).to receive(:process) { processor }
      expect(AlbumsController::AlbumSongProcessor).to receive(:new).with(params, :remove).and_return(processor)
      do_request(params)
    end
  end
end

describe AlbumsController::AlbumSongProcessor do
  let(:album)  { Factory(:album) }
  let(:artist) { Factory(:artist) }
  let(:song_1) { Factory(:song, artist: artist) }
  let(:song_2) { Factory(:song, artist: artist) }
  let(:song_3) { Factory(:song, artist: artist) }
  let(:error_message) { 'some_message' }
  let(:activemodel_errors) { double('ActiveModel::Errors', full_messages: [error_message]) }

  context 'when adding songs' do
    describe '#process' do
      context 'when adding songs' do
        it 'only adds songs not present in the album' do
          [song_1, song_2].each do |song|
            album.album_songs.create(song_id: song.id)
          end
          params = {
            song_ids: [song_1, song_2, song_3].map(&:id).map(&:to_s),
            album_id: album.id
          }
          processor = described_class.new(params, :add)
          expect { processor.process }.to change { AlbumSong.count }.by(1)
          expect(album.reload.songs).to include song_3
        end
      end

      context 'when removing songs' do
        it 'only removes songs not present in the album' do
          [song_1, song_2, song_3].each do |song|
            album.album_songs.create(song_id: song.id)
          end
          params = {
            song_ids: [song_1, song_2].map(&:id).map(&:to_s),
            album_id: album.id
          }
          processor = described_class.new(params, :remove)
          expect { processor.process }.to change { AlbumSong.count }.by(-2)
          expect(album.reload.songs).to eq [song_3]
        end
      end
    end

    describe '#status' do
      context 'when album is not found' do
        it 'returns :not_found status' do
          params = {
            song_ids: [],
            album_id: 1
          }
          processor = described_class.new(params, :add).process
          expect(processor.status).to eq :not_found
        end
      end

      context 'when album is found' do
        let(:params)  { { song_ids: [song_2.id.to_s], album_id: album.id } }

        context 'when process is successful' do
          it 'returns :ok status' do
            processor = described_class.new(params, :add).process
            expect(processor.status).to eq :ok
          end
        end


        context 'when process is unsuccessful' do
          it 'returns :unprocessable_entity status' do
            allow(Album).to receive(:find_by_id) { album }
            allow(album).to receive(:reload) { album }
            allow(album).to receive(:errors) { activemodel_errors }
            processor = described_class.new(params, :add).process
            expect(processor.status).to eq :unprocessable_entity
          end
        end
      end
    end

    describe '#errors' do
      context 'when album is not found' do
        it 'returns an empty array' do
          params = {
            song_ids: [],
            album_id: 1
          }
          processor = described_class.new(params, :add).process
          expect(processor.errors).to eq []
        end
      end

      context 'when album is found' do
        let(:params)  { { song_ids: [song_2.id.to_s], album_id: album.id } }

        context 'when process is successful' do
          it 'returns an empty array' do
            processor = described_class.new(params, :add).process
            expect(processor.errors).to eq []
          end
        end


        context 'when process is unsuccessful' do
          it "returns the album's errors" do
            allow(Album).to receive(:find_by_id) { album }
            allow(album).to receive(:reload) { album }
            allow(album).to receive(:errors) { activemodel_errors }
            processor = described_class.new(params, :add).process
            expect(processor.errors).to eq album.reload.errors.full_messages
          end
        end
      end
    end
  end
end