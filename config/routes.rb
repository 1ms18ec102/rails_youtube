Rails.application.routes.draw do
  devise_for :users
  resources :friends do
    resources :reviews 
  end
  # get 'home/index'
  get 'home/about'
 root 'home#index'
end
