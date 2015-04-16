LockerRoom::Engine.routes.draw do
  root "dashboard#index", as: :root

  get "/signup", to: "accounts#new", as: :signup
  post "/accounts", to: "accounts#create", as: :accounts
end
