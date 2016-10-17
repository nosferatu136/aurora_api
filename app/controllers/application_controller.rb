class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_filter :http_basic_authenticate

  def http_basic_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      HTTP_AUTHENTICATIONS[Rails.env][username] &&
        password == HTTP_AUTHENTICATIONS[Rails.env][username]
    end
  end
end
