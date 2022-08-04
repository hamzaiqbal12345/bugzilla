Rails.application.routes.draw do
  devise_for :users
  root to: 'public#main'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :projects do
    resources :bugs
  end

  resources :home
end

