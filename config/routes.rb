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

      get   '/team/settings', to: 'teams#edit',   as: :edit_team
      patch '/team/settings', to: 'teams#update', as: :team

      get '/team/plan/:plan_id', to: 'teams#plan',      as: :plan_team
      get '/team/subscribe',     to: 'teams#subscribe', as: :subscribe_team

      root 'storages#show', as: :root
    end
  end

  get  '/signin', to: 'sessions#new',    as: nil
  post '/signin', to: 'sessions#create', as: nil
  get  '/signup', to: 'teams#new',    as: nil
  post '/signup', to: 'teams#create', as: nil

  root 'entrance#index', as: nil
end
