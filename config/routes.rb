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

    scope module: :recovery, path: 'recovery' do
      # password
      scope controller: 'passwords' do
        post '/password', action: 'create', as: :password_recovery
        get  '/password', action: 'new',    as: nil
        scope constraints: {token: /[A-z0-9]+/} do
          get   '/password/:token', action: 'edit',   as: nil
          put   '/password/:token', action: 'update', as: nil
          patch '/password/:token', action: 'update', as: nil
        end
      end
    end

    scope module: :settings, path: 'settings' do
      # user
      get   :user, to: 'users#edit',   as: :user_settings
      put   :user, to: 'users#update', as: nil
      patch :user, to: 'users#update', as: nil

      # password
      get   :password, to: 'passwords#edit',   as: :password_settings
      put   :password, to: 'passwords#update', as: nil
      patch :password, to: 'passwords#update', as: nil

      # team
      get   :team, to: 'teams#edit',   as: :team_settings
      put   :team, to: 'teams#update', as: nil
      patch :team, to: 'teams#update', as: nil

      # team:type
      scope path: 'team' do
        scope constraints: {type_id: /[0-9]+/} do
          get   '/type/:type_id', to: 'teams#type',     as: :team_type_settings
          put   '/type/:type_id', to: 'teams#exchange', as: nil
          patch '/type/:type_id', to: 'teams#exchange', as: nil
        end
        get '/subscribe', to: 'teams#subscribe',
          as: :team_subscription_settings
      end

      # team:mates
      scope path: 'team' do
        resources :mates, only: :index, as: :team_mates_settings
      end
    end
  end

  get  '/signin', to: 'sessions#new',    as: nil
  post '/signin', to: 'sessions#create', as: nil
  get  '/signup', to: 'teams#new',    as: nil
  post '/signup', to: 'teams#create', as: nil

  root 'entrance#index', as: nil
end
