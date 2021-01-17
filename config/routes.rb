Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :books, param: :id_book do
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
  
  authenticated :user do
    ### Redireccion al listado de libros una vez logueado
    root 'books#index', as: :authenticated_root
  end
  
end
