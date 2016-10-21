require 'rails_helper'

describe SongsController do
  include AuthHelper

  before { http_login }

  let(:artist) { Factory(:artist) }

  describe 'create' do
    let(:song_params) { { name: 'La Bamba', duration: 14600, artist_id: artist.id } }
    let(:json) { JSON.parse(response.body) }

    def do_request(params = {})
      post :create, params
    end

    context 'when params are correct' do
      it 'creates a new song' do
        expect { do_request(song_params) }.to change { Song.count }.by(1)
        expect(response).to be_success
        expect(json['errors']).to be_empty
      end
    end

    context 'when params are not correct' do
      it 'does not create a new song' do
        song_params.delete(:name)
        expect { do_request(song_params) }.not_to change { Song.count }
        expect(response).not_to be_success
        expect(json['errors']).to include 'Name can\'t be blank'
      end
    end
  end

  describe 'update' do
    let!(:song) { Factory(:song) }
    let(:new_name) { "Sweet child O'mine" }
    let(:song_params) { { id: song.id, name: new_name, duration: 14600, artist_id: artist.id } }

    def do_request(params = {})
      put :update, params
    end

    context 'when song exists' do
      it 'updates the given song' do
        expect { do_request(song_params) }.not_to change { Song.count }
        expect(response).to be_success
        expect(song.reload.name).to eq new_name
      end
    end

    context 'when song does not exist' do
      it 'returns the correct status' do
        song_params[:id] = song.id + 1
        expect { do_request(song_params) }.not_to change { Song.count }
        expect(response.status).to eq 404
      end
    end
  end

  describe 'delete' do
    def do_request(params = {})
      delete :destroy, params
    end

    context 'when song exists' do
      it 'returns success' do
        song = Factory(:song)
        expect { do_request(id: song.id) }.to change { Song.count }.by(-1)
        expect(response).to be_success
      end
    end

    context 'when song does not exist' do
      it 'returns 404' do
        expect { do_request(id: 1) }.not_to change { Song.count }
        expect(response.status).to eq 404
      end
    end

    context 'when song fails to be deleted' do
      it 'returns 422' do
        song = Factory.stub(:song)
        allow(Song).to receive(:find_by_id) { song }
        allow(song).to receive(:destroy) { false }
        do_request(id: song.id)
        expect(response.status).to eq 422
      end
    end
  end
end
