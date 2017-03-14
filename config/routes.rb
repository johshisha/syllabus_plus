Rails.application.routes.draw do
  resources :stock_subjects, only: [:index, :create, :new, :destroy, :show] do
    collection do
      delete :clear
    end
  end

  root 'faculties#index'
  
  get 'usage' => 'static_pages#usage'
  get 'agreement' => 'static_pages#agreement'
  get 'notice' => 'static_pages#notice'
  
  resources :faculties, only: [:index, :show] do
    collection do
      get :list
    end
  end
end
