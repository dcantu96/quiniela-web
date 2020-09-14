Rails.application.routes.draw do
  root to: 'dashboard#home'
  devise_for :users, controllers: {
    sessions: 'sessions',
    confirmations: 'confirmations',
    registrations: 'registrations',
    passwords: 'passwords'
  }
  namespace :admin do
    root to: 'dashboard#home'
    resources :groups do
      resources :memberships, only: [:destroy, :update] do 
        member do
          get :picks
          get :settings
        end
      end
      member do
        get :table
        get :winners
        get :requests
        get :members
        get :matches
      end
    end
    resources :tournaments do
      resources :weeks, only: [:new, :create]
      member do
        get :weeks
      end
    end
    resources :weeks do
      resources :matches, only: [:new, :create]
    end
    resources :sports do
      resources :teams, only: [:new, :create]
    end

    resources :accounts, only: [:new, :edit, :create, :update]
    resources :matches, only: [:edit, :update, :destroy] do
      member do
        post :set_winner
        post :fetch_winner
      end
    end
    resources :teams, only: [:edit, :update]
    resources :requests, only: [:update]
    resources :picks, only: [:update]
  end

  resources :accounts
  resources :picks
  resources :weeks
  resources :memberships do
    member do
      get :table
      get :picks
      get :members
      get :winners
    end
  end
  resources :groups do
    resources :weeks, only: [:show]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
