Rails.application.routes.draw do
  devise_scope :user do
    unauthenticated do
        root 'devise/sessions#new', as: :unauthenticated_root
    end

    authenticated :user do
      root 'users#show', as: :authenticated_root
    end

    # delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  scope 'fake_fb' do
    devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: "users/omniauth_callbacks" }
  end

  resources :users

  resources :relationships, only: [:create, :destroy]
  resources :posts, only: [:new, :create, :edit, :update, :index]
  resources :comments, only: [:create, :update, :destroy]
  match 'like', to: 'likes#like', via: :post
  match 'unlike', to: 'likes#unlike', via: :delete
end
