TechReviewSite::Application.routes.draw do
  devise_for :users
  root 'reviews#new'
  resources :users, only: :show
  resources :products, only: :show do
    resources :reviews, only: :new
    collection
      get 'search'
    end
  end
end
