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
  get 'q_and_a' => 'static_pages#q_and_a'
  get 'contact' => 'static_pages#contact'
  post 'contact' => 'static_pages#post_contact'
  
  resources :faculties, only: [:index, :show] do
    collection do
      get :list
    end
  end
  
  resources :summarized_subjects, only: [:show]
end
