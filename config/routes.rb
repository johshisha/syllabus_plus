Rails.application.routes.draw do
  root 'faculties#index'
  get 'usage' => 'static_pages#usage'
  resources :faculties, only: [:index, :show] do
    collection do
      get :list
    end
  end
end
