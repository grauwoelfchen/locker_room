Rails.application.routes.draw do
  get 'talks/index'

  get '/talks', to: 'talks#index', as: :talks

  mount LockerRoom::Engine => '/'
end
