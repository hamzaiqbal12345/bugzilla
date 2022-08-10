Rails.application.routes.draw do
  devise_for :users
  root to: 'public#main'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :projects do
    member do
      patch 'add_user'
      patch 'remove_user'
    end
    resources :bugs, except: [:index] do
      patch 'assign'
      patch 'start_working'
      patch 'work_done'
    end
  end

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
