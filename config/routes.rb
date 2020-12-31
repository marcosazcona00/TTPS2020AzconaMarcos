Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :books do
    member do
      put 'export'
      put 'export_all'
    end
  end

  resources :notes do
    member do
      put 'export'
    end
  end    

  put '/books/export_all', to: 'books#export_all' 
end
