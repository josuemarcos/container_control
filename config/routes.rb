Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get "images/index"
  
  resources :containers, only: %i[index show create destroy]
  resources :images, only: [:index]

  patch "/containers/:id", controller: "containers", action: :change_status


end
