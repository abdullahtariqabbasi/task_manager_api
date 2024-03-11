# frozen_string_literal: true

class ApplicationController < ActionController::API
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    if token.present?
      payload = JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256').first
      @current_user = User.find_by(id: payload['user_id'])
    end
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user.present?
  end
end
