require 'rails_helper'

describe ApplicationController, "http_basic_authenticate filter" do

  let(:valid_username) { 'aurora' }
  let(:valid_password) { HTTP_AUTHENTICATIONS[Rails.env][valid_username] }

  controller do
    def index
      render :text => 'success'
    end
  end

  it 'returns a success status given a valid username and password' do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(valid_username, valid_password)
    get :index
    expect(response).to be_successful
  end

  it 'returns a non-authorized status when no credentials are specified' do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(nil, nil)
    get :index
    expect(response.status).to eq(401)
  end
end
