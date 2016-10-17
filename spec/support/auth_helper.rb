module AuthHelper
  def http_login
    user     = 'aurora'
    password = HTTP_AUTHENTICATIONS[Rails.env][user]
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
  end
end
