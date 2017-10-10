Rails.application.routes.draw do
  scope 'fb' do
    devise_for :users
  end

  resources :users

  authenticated :user do
    root 'users#show', as: :authenticated_root
  end

  unauthenticated do
    devise_scope :user do
      root 'devise/sessions#new'
    end
  end

  resources :relationships, only: [:create, :destroy]
end
