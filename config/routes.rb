Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: "users/registrations",
  }

  resources :users, only: :show
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: :create
  end
  root to:"posts#index"
end
