require 'locker_room/constraints/subdomain_required'

LockerRoom::Engine.routes.draw do
  constraints(LockerRoom::Constraints::SubdomainRequired) do
    scope module: 'account' do
      get    '/signout', to: 'sessions#destroy', as: :logout
      delete '/signout', to: 'sessions#destroy', as: nil
      get    '/signin',  to: 'sessions#new',     as: :login
      post   '/signin',  to: 'sessions#create',  as: nil
      get    '/signup',  to: 'users#new',     as: :registration
      post   '/signup',  to: 'users#create',  as: nil

      root 'storages#show', as: :root
    end

    scope module: 'settings', path: 'settings' do
      # user
      get      :user, to: 'users#edit', as: :user_settings
      resource :user, only: [:update],  as: :user_settings
      get      :password, to: 'passwords#edit', as: :password_settings
      resource :password, only: [:update],      as: :password_settings

      # team
      get      :team, to: 'teams#edit', as: :team_settings
      resource :team, only: [:update],  as: :team_settings

      scope path: 'team' do
        get  '/subscribe',     to: 'teams#subscribe',    as: :subscribe_team
        get  '/type/:type_id', to: 'teams#type',         as: :team_type
        post '/confirm_type',  to: 'teams#confirm_type', as: :confirm_team_type
      end

      # mates
      get :mates, to: 'mates#index', path: 'mates', as: :mate_settings
    end
  end

  get  '/signin', to: 'sessions#new',    as: nil
  post '/signin', to: 'sessions#create', as: nil
  get  '/signup', to: 'teams#new',    as: nil
  post '/signup', to: 'teams#create', as: nil

  root 'entrance#index', as: nil
end
