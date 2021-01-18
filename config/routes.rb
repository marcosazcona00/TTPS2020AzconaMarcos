Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  ### El member me permite agregar con un metodo http distinto un controlador en las rutas con su path
  ### Ej: export_all_path, export_path, ambos por put
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

  
  authenticated :user do
    ### Redireccion al listado de libros una vez logueado
    root 'books#index', as: :authenticated_root
  end
  
  devise_scope :user do
    ### En caso de no estar logueado redirecciona al login
    root to: 'devise/sessions#new'
  end
  
  #put '/books/export_all', to: 'books#export_all'
end
