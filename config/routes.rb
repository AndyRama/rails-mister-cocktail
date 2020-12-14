Rails.application.routes.draw do
  root to:'cocktails#index'
  resources :cocktails, only: %i[new show create index] do
    resources :doses, only: %i[new create]
    #resources :reviews, only: [:create]
  end
  resources :doses, only: [:detroy]
end
