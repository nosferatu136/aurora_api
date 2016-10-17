module AuthHelper
  def http_login
    user     = 'some_client'
    password = HTTP_AUTHENTICATIONS[Rails.env][user]
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
  end
end
