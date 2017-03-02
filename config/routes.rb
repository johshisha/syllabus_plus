Rails.application.routes.draw do
  resources :faculties, only: [:index, :show]
end
