Rails.application.routes.draw do
  root 'faculties#index'
  resources :faculties, only: [:index, :show] do
    collection do
      get :list
    end
  end
end
