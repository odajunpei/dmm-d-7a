Rails.application.routes.draw do
  root to: 'homes#top'
  get 'home/about' => 'homes#about'
  devise_for :users
  resources :books, only: [:new, :create, :index, :show, :destroy, :edit, :update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:show, :edit, :update, :index, :follow, :follower] do
    member do
      get :followings
      get :followers
    end
  end
  resources :relationships, only: [:create, :destroy]
  get 'search' => 'searchs#search'
end
