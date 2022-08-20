Rails.application.routes.draw do
  root to: 'dashboard#home'
  get '/dashboard/join-groups', to: 'dashboard#join_groups'
  devise_for :users, controllers: {
    sessions: 'sessions',
    confirmations: 'confirmations',
    registrations: 'registrations',
    passwords: 'passwords'
  }
  namespace :admin do
    root to: 'dashboard#home'
    resources :memberships, only: [:update]
    resources :groups do
      resources :memberships, only: [:destroy, :update] do 
        member do
          get :picks
          get :settings
        end
      end
      resources :matches, only: [:update] do
        member do
          post :fetch_winner
        end
      end
      member do
        get :table
        get :members_forgetting
        get :winners
        get :settings
        get :requests
        get :members
        get :matches
        get :autocomplete
        post :reset_week_points
        post :fetch_match_results
        post :update_picks
        post :update_total_points
        post :notify_missing_picks
      end
    end
    resources :tournaments do
      resources :groups, only: [:index]
      resources :weeks, only: [:new, :create] do 
        member do
          post :update_matches
        end
      end
      member do
        get :weeks
        post :update_week_matches
        post :generate_week_matches
      end
    end
    resources :weeks do
      resources :matches, only: [:new, :create]
      member do
        post :generate_week_matches
      end
    end
    resources :sports do
      resources :teams, only: [:new, :create]
    end
    resources :winners, only: [:create]
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
    resources :updates
  end

  resources :accounts
  resources :picks
  resources :weeks
  resources :requests, only: [:create]
  resources :memberships do
    member do
      get :table
      get :picks
      get :public_picks
      get :members
      get :winners
      get :autocomplete
    end
  end
  resources :groups do
    resources :weeks, only: [:show]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
