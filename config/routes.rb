Blog::Application.routes.draw do
  root to: "articles#index"

  resources :articles do
    member do
      post :notify_friend
    end
    resources :comments, only: [:new, :create, :destroy]
  end

  resources :users, only: [:new, :create, :edit, :update]

  resource :session, only: [:create, :destroy]
  get '/login'  => "sessions#new",     as: "login"
  get '/logout' => "sessions#destroy", as: "logout"
end