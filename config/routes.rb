Rails.application.routes.draw do

  root 'users/translations#new'

  resource :session, controller: "user_sessions", only: [:create, :destroy]
  get 'session', to: 'user_sessions#new'

  resources :users do
    scope module: 'users' do
      resource :password, only: [:update], controller: 'password'
      resources :translations, except: :update
    end
  end
  get '/users/verification/:token' => 'users#verify', as: 'verification'
  get '/auth/:provider/callback', :to => 'auth#callback'
end
