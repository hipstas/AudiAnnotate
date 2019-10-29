Rails.application.routes.draw do
  root to: 'project#all'

  get 'project/all'
  get 'project/mine'
  get 'project/:user_name/:repo_name', to: 'project#show', as: 'project'

  get 'user/login'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/auth/github/callback', to: 'user#login'
end
