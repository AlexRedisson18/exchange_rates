Rails.application.routes.draw do
  root 'exchange_rates#index'
  resources :exchange_rates, only: [:index] do
    get :price_changes, on: :collection
  end
end
