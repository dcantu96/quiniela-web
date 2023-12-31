Rails.application.routes.draw do
  authenticate :user, -> (user) { user.admin? } do
    mount GoodJob::Engine => 'good_job'
  end
  root to: 'dashboard#home'
  get '/join-groups', to: 'dashboard#join_groups'
  get '/not-paid', to: 'not_paid#index'
  get '/rules', to: 'public#rules'
  get '/prizes', to: 'public#prizes'
  devise_for :users, controllers: {
    sessions: 'sessions',
    confirmations: 'confirmations',
    registrations: 'registrations',
    passwords: 'passwords'
  }
  namespace :admin do
    resources :users, only: [:index, :show]
    resources :memberships, only: [:update, :create, :destroy] do
      member do
        patch :reset
      end
    end
    resources :groups do
      resources :memberships, only: [:update] do 
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
      resources :group_weeks, only: [:index, :show, :edit, :update], as: :weeks
      member do
        get :table
        get :users
        get :users_not_paid
        get :members_forgetting
        get :danger_settings
        get :winners
        get :settings
        get :requests
        get :members
        get :matches
        get :autocomplete
        get :inactive_accounts
        post :reset_week_points
        post :fetch_match_results
        post :update_picks
        post :update_total_points
        post :notify_missing_picks
        patch :update_memberships
      end
    end
    resources :blog_posts
    resources :tournaments do
      resources :weeks, only: [:new, :create]
      member do
        get :weeks
        patch :setup
      end
    end
    resources :weeks do
      resources :matches, only: [:new, :create]
      member do
        patch :update_week
        patch :delete_matches
        patch :toggle_finished
      end
    end
    resources :sports do
      resources :teams, only: [:new, :create]
    end
    resources :winners, only: [:create]
    resources :accounts, only: [:index, :new, :edit, :create, :update, :destroy]
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
  resources :memberships, expect: [:delete, :update, :index] do
    member do
      get :search
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
