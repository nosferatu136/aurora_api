AuroraApi::Application.routes.draw do
  resources :artists, only: [:index, :create, :update, :destroy]
end
