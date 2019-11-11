Rails.application.routes.draw do
  # resources :annotation_files
  post 'project/:user_name/:repo_name/items', to: 'items#create', as: 'create_item'
  get 'project/:user_name/:repo_name/items/new', to: 'items#new', as: 'new_item'
  get 'project/:user_name/:repo_name/items/:label/edit', to: 'items#edit', as: 'edit_item'
  get 'project/:user_name/:repo_name/items/:label', to: 'items#show', as: 'item'
  patch 'project/:user_name/:repo_name/items/:label', to: 'items#update', as: 'update_item'
  delete 'project/:user_name/:repo_name/items/:label', to: 'items#destroy', as: 'destroy_item'
  post 'project/:user_name/:repo_name/items/:label/files', to: 'items#add_annotation_file', as: 'add_annotation_file'

  root to: 'project#all'

  get 'project/all', as: 'all_projects'
  get 'project/mine', as: 'my_projects'
  get 'project/:user_name/:repo_name', to: 'project#show', as: 'project'
  get 'project/new', to: 'project#new', as: 'new_project'
  post 'project', to: 'project#create', as: 'create_project'


  get 'user/login'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/auth/github/callback', to: 'user#login'
end
