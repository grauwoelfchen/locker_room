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

    scope module: 'recovery', path: 'recovery', controller: 'passwords' do
      # password
      post '/password', action: 'create', as: :password_recoveries
      get  '/password', action: 'new',    as: :new_password_recovery
      scope constraints: {token: /[A-z0-9]+/} do
        get   '/password/:token', action: 'edit',   as: :edit_password_recovery
        put   '/password/:token', action: 'update', as: :password_recovery
        patch '/password/:token', action: 'update'
      end
    end

    scope module: 'settings', path: 'settings' do
      # user
      get      :user, to: 'users#edit', as: :edit_user
      resource :user, only: :update

      # password
      get      :password, to: 'passwords#edit', as: :edit_password
      resource :password, only: :update

      # team
      get      :team, to: 'teams#edit', as: :edit_team
      resource :team, only: :update

      scope path: 'team' do
        get  '/subscribe',     to: 'teams#subscribe',    as: :subscribe_team
        get  '/type/:type_id', to: 'teams#type',         as: :team_type
        post '/type/confirm',  to: 'teams#confirm_type', as: :confirm_team_type
      end

      # mates
      resources :mates, only: :index
    end
  end

  get  '/signin', to: 'sessions#new',    as: nil
  post '/signin', to: 'sessions#create', as: nil
  get  '/signup', to: 'teams#new',    as: nil
  post '/signup', to: 'teams#create', as: nil

  root 'entrance#index', as: nil
end
