require 'rails_helper'

describe PlaylistsController do
  include AuthHelper

  before { http_login }


  describe 'create' do
    let(:artist) { Factory(:artist, name: 'Guns n Roses') }
    let(:playlist_params) do
      {
        name: 'My music',
        user_id: 123
      }
    end

    let(:json) { JSON.parse(response.body) }

    def do_request(params = {})
      post :create, params
    end

    context 'when params are correct' do
      it 'creates a new playlist' do
        expect { do_request(playlist_params) }.to change { Playlist.count }.by(1)
        expect(response).to be_success
        expect(json['errors']).to be_empty
      end
    end

    context 'when params are not correct' do
      it 'does not create a new playlist' do
        playlist_params.delete(:name)
        expect { do_request(playlist_params) }.not_to change { Playlist.count }
        expect(response).not_to be_success
        expect(json['errors']).to include 'Name can\'t be blank'
      end
    end
  end

  describe 'update' do
    let!(:playlist) { Factory(:playlist) }
    let(:new_name) { 'Soft rock' }
    let(:playlist_params) { { id: playlist.id, name: new_name } }

    def do_request(params = {})
      put :update, params
    end

    context 'when playlist exists' do
      it 'updates the given playlist' do
        expect { do_request(playlist_params) }.not_to change { Playlist.count }
        expect(response).to be_success
        expect(playlist.reload.name).to eq new_name
      end
    end

    context 'when playlist does not exist' do
      it 'returns the correct status' do
        playlist_params[:id] = playlist.id + 1
        expect { do_request(playlist_params) }.not_to change { Playlist.count }
        expect(response.status).to eq 404
      end
    end
  end

  describe 'delete' do
    def do_request(params = {})
      delete :destroy, params
    end

    context 'when playlist exists' do
      it 'returns success' do
        playlist = Factory(:playlist)
        do_request(id: playlist.id)
        expect(response).to be_success
      end
    end

    context 'when playlist does not exist' do
      it 'returns 404' do
        do_request(id: 1)
        expect(response.status).to eq 404
      end
    end

    context 'when playlist fails to be deleted' do
      it 'returns 422' do
        playlist = Factory.stub(:playlist)
        allow(Playlist).to receive(:find_by_id) { playlist }
        allow(playlist).to receive(:destroy) { false }
        do_request(id: playlist.id)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'add_songs' do
    def do_request(params)
      post :add_songs, params
    end

    it 'instantiates a song processor to perform the action' do
      playlist = Factory.stub(:playlist)
      params = {
        'playlist_id' => playlist.id.to_s,
        'song_ids' => ['1', '2', '3']
      }
      processor = double('PlaylistSongProcessor', playlist: playlist, status: :ok, errors: [])
      allow(processor).to receive(:process) { processor }
      expect(PlaylistsController::PlaylistSongProcessor).to receive(:new).with(params, :add).and_return(processor)
      do_request(params)
    end
  end

  describe 'remove_songs' do
    def do_request(params)
      post :remove_songs, params
    end

    it 'instantiates a song processor to perform the action' do
      playlist = Factory.stub(:playlist)
      params = {
        'playlist_id' => playlist.id.to_s,
        'song_ids' => ['1', '2', '3']
      }
      processor = double('PlaylistSongProcessor', playlist: playlist, status: :ok, errors: [])
      allow(processor).to receive(:process) { processor }
      expect(PlaylistsController::PlaylistSongProcessor).to receive(:new).with(params, :remove).and_return(processor)
      do_request(params)
    end
  end
end

describe PlaylistsController::PlaylistSongProcessor do
  let(:playlist)  { Factory(:playlist) }
  let(:artist) { Factory(:artist) }
  let(:song_1) { Factory(:song, artist: artist) }
  let(:song_2) { Factory(:song, artist: artist) }
  let(:song_3) { Factory(:song, artist: artist) }
  let(:error_message) { 'some_message' }
  let(:activemodel_errors) { double('ActiveModel::Errors', full_messages: [error_message]) }

  context 'when adding songs' do
    describe '#process' do
      context 'when adding songs' do
        it 'only adds songs not present in the playlist' do
          [song_1, song_2].each do |song|
            playlist.playlist_songs.create(song_id: song.id)
          end
          params = {
            song_ids: [song_1, song_2, song_3].map(&:id).map(&:to_s),
            playlist_id: playlist.id
          }
          processor = described_class.new(params, :add)
          expect { processor.process }.to change { PlaylistSong.count }.by(1)
          expect(playlist.reload.songs).to include song_3
        end
      end

      context 'when removing songs' do
        it 'only removes songs not present in the playlist' do
          [song_1, song_2, song_3].each do |song|
            playlist.playlist_songs.create(song_id: song.id)
          end
          params = {
            song_ids: [song_1, song_2].map(&:id).map(&:to_s),
            playlist_id: playlist.id
          }
          processor = described_class.new(params, :remove)
          expect { processor.process }.to change { PlaylistSong.count }.by(-2)
          expect(playlist.reload.songs).to eq [song_3]
        end
      end
    end

    describe '#status' do
      context 'when playlist is not found' do
        it 'returns :not_found status' do
          params = {
            song_ids: [],
            playlist_id: 1
          }
          processor = described_class.new(params, :add).process
          expect(processor.status).to eq :not_found
        end
      end

      context 'when playlist is found' do
        let(:params)  { { song_ids: [song_2.id.to_s], playlist_id: playlist.id } }

        context 'when process is successful' do
          it 'returns :ok status' do
            processor = described_class.new(params, :add).process
            expect(processor.status).to eq :ok
          end
        end


        context 'when process is unsuccessful' do
          it 'returns :unprocessable_entity status' do
            allow(Playlist).to receive(:find_by_id) { playlist }
            allow(playlist).to receive(:reload) { playlist }
            allow(playlist).to receive(:errors) { activemodel_errors }
            processor = described_class.new(params, :add).process
            expect(processor.status).to eq :unprocessable_entity
          end
        end
      end
    end

    describe '#errors' do
      context 'when playlist is not found' do
        it 'returns an empty array' do
          params = {
            song_ids: [],
            playlist_id: 1
          }
          processor = described_class.new(params, :add).process
          expect(processor.errors).to eq []
        end
      end

      context 'when playlist is found' do
        let(:params)  { { song_ids: [song_2.id.to_s], playlist_id: playlist.id } }

        context 'when process is successful' do
          it 'returns an empty array' do
            processor = described_class.new(params, :add).process
            expect(processor.errors).to eq []
          end
        end


        context 'when process is unsuccessful' do
          it "returns the playlist's errors" do
            allow(Playlist).to receive(:find_by_id) { playlist }
            allow(playlist).to receive(:reload) { playlist }
            allow(playlist).to receive(:errors) { activemodel_errors }
            processor = described_class.new(params, :add).process
            expect(processor.errors).to eq playlist.reload.errors.full_messages
          end
        end
      end
    end
  end
end