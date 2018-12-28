Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Begin API route
  namespace :api do
    # v1
    namespace :v1 do
      resources :bots, defaults: {format: :json}
      resources :questions
        resources :responses
    end
  end
  # End API route
  match '/' => redirect('/questions'), via: :get
  # Below: Public FE routes
  resources :questions do
    resources :responses
  end
end
