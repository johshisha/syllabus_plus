Rails.application.routes.draw do
  root 'faculties#index'
  
  get 'usage' => 'static_pages#usage'
  get 'stocked' => 'static_pages#stocked'
  
  resources :faculties, only: [:index, :show] do
    collection do
      get :list
    end
  end
end
