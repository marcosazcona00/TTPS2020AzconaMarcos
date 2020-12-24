Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :books
  resources :notes, path_names: { new: ':id/new' }, except: [:create]
  post '/notes/:id' => 'notes#create' 
  
  #put '/notes/:id/export' => 'notes#export'
  #get '/notes/:id/new' => 'notes#new' 
  #post '/notes/:id' => 'notes#create' 

end
