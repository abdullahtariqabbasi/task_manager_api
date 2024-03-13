# frozen_string_literal: true

require 'jwt'
require 'bcrypt'
# app/controllers/user_controller.rb
class UserController < ApplicationController
  before_action :set_user, only: [:login]
  before_action :authenticate_user!, only: [:show]

  def create
    @user = User.new(user_params)
    if @user.save
      payload = { user_id: @user.id }
      secret = Rails.application.secrets.secret_key_base
      token = JWT.encode payload, secret, 'HS256'
      render json: token, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    if @user.present? && @user.authenticate(user_params[:password])
      payload = { user_id: @user.id }
      secret = Rails.application.secrets.secret_key_base
      token = JWT.encode payload, secret, 'HS256'
      render json: token, status: :created
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def show
    render json: @current_user, status: :ok
  end

  private

  def set_user
    @user = User.find_by(email: user_params[:email])
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
