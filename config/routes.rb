require "locker_room/constraints/subdomain_required"

LockerRoom::Engine.routes.draw do
  constraints(LockerRoom::Constraints::SubdomainRequired) do
    scope module: "account" do
      delete :logout, to: "sessions#destroy", as: :logout
      get    :login,  to: "sessions#new",     as: :login
      post   :login,  to: "sessions#create",  as: nil
      get    :signup, to: "users#new",        as: :user_signup
      post   :signup, to: "users#create",     as: nil
      root "dashboard#index", as: :account_root
    end
  end

  root "dashboard#index", as: :root

  get  "/signup",   to: "accounts#new",    as: :signup
  post "/accounts", to: "accounts#create", as: :accounts
end
