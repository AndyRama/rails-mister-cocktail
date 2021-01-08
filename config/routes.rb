Rails.application.routes.draw do
  root to: "cocktails#index"

  resources :cocktails, only: [:index, :show, :new, :create] do
    resources :doses, only: [:new, :create, :destroy]
  end

  resources :doses, only: [:destroy,:update]
  # to nest doses later
end