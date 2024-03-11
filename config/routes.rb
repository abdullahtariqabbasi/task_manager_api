# frozen_string_literal: true

Rails.application.routes.draw do
  post '/users', to: 'user#create'
  post '/login', to: 'user#login'
  get '/users/:id', to: 'user#show'
end
