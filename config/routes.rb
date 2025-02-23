Rails.application.routes.draw do
  
  resources :containers, only: %i[index show create destroy]

  patch "/containers/:id", controller: "containers", action: :change_status


end
