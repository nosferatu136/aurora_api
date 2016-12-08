require 'rails_helper'

describe AlbumsController do
  include AuthHelper

  before { http_login }

  describe 'show' do
    def do_request(id)
      get :show, guid: id
    end

    context 'when album exists' do
      it 'retrieves the given album' do
        album = Factory(:album)
        do_request(album.guid)
        expect(response).to be_success
        expect(response.status).to eq 200
      end
    end

    context 'when album does not exist' do
      it 'retruns the correct response' do
        do_request(1)
        expect(response).not_to be_success
        expect(response.status).to eq 404
      end
    end
  end

  describe 'create' do
    let(:artist) { Factory(:artist, name: 'Guns n Roses') }
    let(:album_params) do
      {
        name: 'Appetite for destruction',
        artist_guid: artist.guid,
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
    let(:album_params) { { guid: album.guid, name: new_name } }

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
        album_params[:guid] = 'some_nice_guid'
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
        do_request(guid: album.guid)
        expect(response).to be_success
      end
    end

    context 'when album does not exist' do
      it 'returns 404' do
        do_request(guid: SecureRandom.uuid)
        expect(response.status).to eq 404
      end
    end

    context 'when album fails to be deleted' do
      it 'returns 422' do
        album = Factory.stub(:album)
        allow(Album).to receive(:find_by_guid) { album }
        allow(album).to receive(:destroy) { false }
        do_request(guid: album.guid)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'add_songs' do
    def do_request(params)
      post :add_songs, params
    end

    it 'calls the correct method to add songs to the album' do
      album = Factory.stub(:album)
      allow(Album).to receive(:find_by_guid) { album }
      params = {
        'album_guid' => album.guid,
        'song_guids' => 3.times.map { |time| SecureRandom.uuid }
      }
      expect(album).to receive(:add_songs).with(params['song_guids'])
      do_request(params)
    end
  end

  describe 'remove_songs' do
    def do_request(params)
      delete :remove_songs, params
    end

    it 'calls the correct method to remove songs from the album' do
      album = Factory.stub(:album)
      allow(Album).to receive(:find_by_guid) { album }
      params = {
        'album_guid' => album.guid,
        'song_guids' => 3.times.map { |time| SecureRandom.uuid }
      }
      expect(album).to receive(:remove_songs).with(params['song_guids'])
      do_request(params)
    end
  end
end
