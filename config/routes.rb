Rails.application.routes.draw do
  
  resources :containers

  patch '/containers/:id', to: 'container#change_status'

end
