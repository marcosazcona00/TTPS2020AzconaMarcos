Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  ### El member me permite agregar con un metodo http distinto un controlador en las rutas con su path
  ### Ej: export_all_path, export_path, ambos por put
  #resources :books, param: :id_book do
  #  member do
  #    put 'export'
  #    put 'export_all'
  #  end
  #end

  # Con el param: cambiamos el parametro por defecto /:id/ por /:id_book/
  put '/books/export', to: 'books#export', as: 'book_export'
  put '/books/export_all', to: 'books#export_all', as: 'book_export_all'

  devise_for :users

  resources :books, param: :id_book

  resources :notes do
    member do
      put 'export'
      get 'download'
    end
  end    

  
  authenticated :user do
    ### Redireccion al listado de libros una vez logueado
    root 'books#index', as: :authenticated_root
  end
  
  devise_scope :user do
    ### En caso de no estar logueado redirecciona al login
    root to: 'devise/sessions#new'
  end
  
end
