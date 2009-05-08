ActionController::Routing::Routes.draw do |map|
  map.resources :albums do |albums|
    albums.resources :pictures
  end

  map.root :controller => 'pictures'

  map.resources :friendships

  map.resources :tags

  map.resources :people do |people|
    people.resources :pictures, :collection => {:mine => :get} 
  end

  map.resources :pictures, :member => {:serve => :get, :serve_thumbnail => :get}, :collection => {:tagged => :get} do |pictures|
    pictures.resources :taggings
    pictures.resources :comments
  end
   
  map.resource :session
    
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
