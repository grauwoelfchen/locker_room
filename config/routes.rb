require "locker_room/constraints/subdomain_required"

LockerRoom::Engine.routes.draw do
  constraints(LockerRoom::Constraints::SubdomainRequired) do
    scope module: "member" do
      get    "/signout", to: "sessions#destroy", as: :logout
      delete "/signout", to: "sessions#destroy", as: nil
      get    "/signin",  to: "sessions#new",     as: :login
      post   "/signin",  to: "sessions#create",  as: nil
      get    "/signup",  to: "users#new",     as: :registration
      post   "/signup",  to: "users#create",  as: nil

      root "storages#show", as: :root
    end
  end

  get  "/signin", to: "sessions#new",    as: nil
  post "/signin", to: "sessions#create", as: nil
  get  "/signup", to: "teams#new",    as: nil
  post "/signup", to: "teams#create", as: nil

  root "entrance#index", as: nil
end
