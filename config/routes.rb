Rails.application.routes.draw do
  get 'home/index'
  get 'projects/index'
  get 'projects/show'
  get 'projects/new'
  get 'projects/edit'
  get 'bugs/index'
  get 'bugs/new'
  get 'bugs/edit'
  get 'bugs/show'
  devise_for :users
  root to: 'public#main'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
