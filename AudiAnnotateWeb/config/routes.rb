Rails.application.routes.draw do
  root to: 'project#all'

  get 'project/all'
  get 'user/login'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
