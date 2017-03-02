Rails.application.routes.draw do
  root 'faculties#index'
  resources :faculties, only: [:index, :show]
end
