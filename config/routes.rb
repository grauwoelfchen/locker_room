require "locker_room/constraints/subdomain_required"

LockerRoom::Engine.routes.draw do
  constraints(LockerRoom::Constraints::SubdomainRequired) do
    scope module: "account" do
      get    :logout, to: "sessions#destroy", as: :logout
      delete :logout, to: "sessions#destroy", as: nil
      get    :login,  to: "sessions#new",     as: :login
      post   :login,  to: "sessions#create",  as: nil
      get    :signup, to: "users#new",        as: :signup
      post   :signup, to: "users#create",     as: nil
      root "locker#index", as: :root
    end
  end

  get  "/login",  to: "login#new",       as: nil
  post "/login",  to: "login#create",    as: nil
  get  "/signup", to: "accounts#new",    as: nil
  post "/signup", to: "accounts#create", as: nil
  root "entrance#index", as: nil
end
