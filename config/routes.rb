Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api do
    post 'login', to: 'users#login'
    get 'feed', to: 'scores#user_feed'
    get 'golfers/:id/scores', to: 'users#scores'
    get 'golfers/:id/name', to: 'users#name'
    resources :scores, only: %i[create destroy]
  end
end
