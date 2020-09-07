Rails.application.routes.draw do
  root to: 'dashboard#home'
  devise_for :users, controllers: {
    sessions: 'sessions',
    confirmations: 'confirmations',
    registrations: 'registrations'
  }
  namespace :admin do
    root to: 'dashboard#home'
    resources :groups do
      member do
        get :winners
        get :picks
        get :requests
      end
    end
    resources :memberships
    resources :picks, only: [:update]
    resources :accounts
    resources :requests
    resources :teams
    resources :tournaments do
      resources :weeks, only: [:new, :create]
      member do
        get :weeks
      end
    end
    resources :weeks do
      resources :matches, only: [:new, :create]
      member do
        post :generate
      end
    end
    resources :matches
    resources :sports do
      resources :teams, only: [:new, :create]
    end
  end

  resources :accounts

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
