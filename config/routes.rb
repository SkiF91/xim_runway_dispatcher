Rails.application.routes.draw do
  root to: 'home#index', as: 'home'

  resources :aircrafts, only: [:index, :create] do
    member do
      get :history
      post :to_runway
      post :cancel
    end
  end
end
