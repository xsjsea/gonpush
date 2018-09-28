Rails.application.routes.draw do
 
  resources :socail_accounts
  resources :social_channels
  resources :cases
  resources :reports
  get 'sessions/new'
  resources :tasks
  resources :orders
  resources :tags
  resources :schedules
  resources :areas
  resources :comments
  resources :contracts
  resources :posts
  resources :flows
  resources :social_accounts
  resources :categories
  resources :creator_exts
  resources :metrics
  resources :creator_metrics
  resources :services
  resources :users
  resources :campaigns
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login' , to:'sessions#create'
  get '/logout' , to: 'sessions#destrory'
  get '/getOrder', to: 'orders#showOrder'
  post '/updateSchedule', to: 'orders#updateSchedule'
  delete "orders/destroy/:id" => "orders#destroy"
  delete "reports/destroy/:id" => "reports#destroy"
  delete "cases/destroy/:id" => "cases#destroy"
  delete "services/destroy/:id" => "services#destroy"
  post  '/getservice',to:'sessions#getservices'
  get '/inviterequired', to: 'users#inviterequired'
  post '/saveinviterequired' , to:'users#saveinviterequired'
  get '/updatepassword', to: 'users#updatepassword'
  post '/savepassword' , to:'users#savepassword'
  get '/userinfo', to: 'users#userinfo'
  post '/saveuserinfo' , to:'users#saveuserinfo'

end
