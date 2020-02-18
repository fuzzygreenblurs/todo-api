require './config/environment'

class ApplicationController < Sinatra::Base
  attr_accessor :current_user

  PUBLIC_ENDPOINTS = ['/', '/login', '/signup']

  before do
    content_type :json
    convert_params_to_json

    skip_authorization_for_public_endpoints
    authorize_request!
  end

  def api_response(status = 200, data = {}, errors = [])
    ret = {
      data: data,
      errors: errors
    }
    response.status = status
    halt ret.to_json
  end

  get "/" do
    api_response(200, { msg: "this application is healthy!" })
  end

  def convert_params_to_json
     if request.media_type == 'application/json' && !(body = request.body.read).empty?
      request.body.rewind
      params.update(JSON.parse(body))
    end
  end

  def encoded_token
    payload = {
      issued_at: Time.now.to_i,
      expires_at: Time.now.to_i + 3600,
      user_identifier: params[:email],
      #can add role capability
    }

    JWT.encode(payload, 'MY_JWT_SECRET', 'HS256')
  end

  def authorize_request!
    if user_identifier_in_token?
      @current_user = User.find_by(email: decoded_payload[:user_identifier])
      return true unless @current_user
    end

    halt 401
  rescue JWT::VerificationError, JWT::DecodeError
    api_response(401, {}, ['Invalid JWT token'])
  end

  private

  def incoming_token
    @incoming_token ||= if request.env['HTTP_AUTHORIZATION'].present?
      request.env['HTTP_AUTHORIZATION'].split(' ').last
    end
  end

  def decoded_payload
    @decoded_payload ||= JWT.decode(incoming_token, 'MY_JWT_SECRET', 'HS256').first
  end

  def user_identifier_in_token?
    incoming_token &&
    decoded_payload &&
    decoded_payload['user_identifier'] &&
    Time.now.to_i < decoded_payload['expires_at']
  end

  def skip_authorization_for_public_endpoints
    pass if PUBLIC_ENDPOINTS.include?(request.path_info)
  end
end