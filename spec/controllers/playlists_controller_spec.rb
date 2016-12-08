require 'rails_helper'

describe PlaylistsController do
  include AuthHelper

  before { http_login }

  describe 'show' do
    def do_request(guid)
      get :show, guid: guid
    end

    context 'when playlist exists' do
      it 'retrieves the given playlist' do
        playlist = Factory(:playlist)
        do_request(playlist.guid)
        expect(response).to be_success
        expect(response.status).to eq 200
      end
    end

    context 'when playlist does not exist' do
      it 'retruns the correct response' do
        do_request('blah')
        expect(response).not_to be_success
        expect(response.status).to eq 404
      end
    end
  end

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
    let(:playlist_params) { { guid: playlist.guid, name: new_name } }

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
        playlist_params[:guid] = 'some_nice_guid'
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
        do_request(guid: playlist.guid)
        expect(response).to be_success
      end
    end

    context 'when playlist does not exist' do
      it 'returns 404' do
        do_request(guid: 'hmmm')
        expect(response.status).to eq 404
      end
    end

    context 'when playlist fails to be deleted' do
      it 'returns 422' do
        playlist = Factory.stub(:playlist)
        allow(Playlist).to receive(:find_by_guid) { playlist }
        allow(playlist).to receive(:destroy) { false }
        do_request(guid: playlist.guid)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'add_songs' do
    def do_request(params)
      post :add_songs, params
    end

    it 'calls the correct method to add songs to the playlist' do
      playlist = Factory.stub(:playlist)
      allow(Playlist).to receive(:find_by_guid) { playlist }
      params = {
        'playlist_guid' => playlist.id.to_s,
        'song_guids' => 3.times.map { |time| SecureRandom.uuid }
      }
      expect(playlist).to receive(:add_songs).with(params['song_guids'])
      do_request(params)
    end
  end

  describe 'remove_songs' do
    def do_request(params)
      post :remove_songs, params
    end

    it 'calls the correct method to remove songs from the playlist' do
      playlist = Factory.stub(:playlist)
      allow(Playlist).to receive(:find_by_guid) { playlist }
      params = {
        'playlist_guid' => playlist.id.to_s,
        'song_guids' => 3.times.map { |time| SecureRandom.uuid }
      }
      expect(playlist).to receive(:remove_songs).with(params['song_guids'])
      do_request(params)
    end
  end
end
