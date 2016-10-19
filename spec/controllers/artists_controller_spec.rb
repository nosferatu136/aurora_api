require 'rails_helper'

describe ArtistsController do
  include AuthHelper

  before { http_login }

  describe 'create' do

    let(:artist_params) { { name: 'Mark Walberg', bio: 'A very short bio', alias: 'Marky Mark' } }
    let(:json) { JSON.parse(response.body) }

    def do_request(params = {})
      post :create, params
    end

    context 'when params are correct' do
      it 'creates a new artist' do
        expect { do_request(artist_params) }.to change { Artist.count }.by(1)
        expect(response).to be_success
        expect(json['errors']).to be_empty
      end
    end

    context 'when params are not correct' do
      it 'does not create a new artist' do
        artist_params.delete(:name)
        expect { do_request(artist_params) }.not_to change { Artist.count }
        expect(response).not_to be_success
        expect(json['errors']).to include 'Name can\'t be blank'
      end
    end

    context 'when params exists an artist with the same name' do
      it 'does not create a new artist' do
        artist_name = 'Frank Sinatra'
        Factory(:artist, name: artist_name)
        artist_params[:name] = artist_name
        expect { do_request(artist_params) }.not_to change { Artist.count }
        expect(response).not_to be_success
        expect(json['errors']).to include 'Name has already been taken'
      end
    end
  end

  describe 'update' do
    let!(:artist) { Factory(:artist) }
    let(:new_name) { 'Godsmack' }
    let(:artist_params) { { id: artist.id, name: new_name, bio: 'A very short bio', alias: 'Marky Mark' } }

    def do_request(params = {})
      put :update, params
    end

    context 'when artist exists' do
      it 'updates the given artist' do
        expect { do_request(artist_params) }.not_to change { Artist.count }
        expect(response).to be_success
        expect(artist.reload.name).to eq new_name
      end
    end

    context 'when artist does not exist' do
      it 'returns the correct status' do
        artist_params[:id] = artist.id + 1
        expect { do_request(artist_params) }.not_to change { Artist.count }
        expect(response.status).to eq 404
      end
    end
  end

  describe 'delete' do
    def do_request(params = {})
      delete :destroy, params
    end

    context 'when artist exists' do
      it 'returns success' do
        artist = Factory(:artist)
        do_request(id: artist.id)
        expect(response).to be_success
      end
    end

    context 'when artist does not exist' do
      it 'returns 404' do
        do_request(id: 1)
        expect(response.status).to eq 404
      end
    end

    context 'when artist fails to be deleted' do
      it 'returns 422' do
        artist = Factory.stub(:artist)
        allow(Artist).to receive(:find_by_id) { artist }
        allow(artist).to receive(:destroy) { false }
        do_request(id: artist.id)
        expect(response.status).to eq 422
      end
    end
  end
end
