Rails.application.routes.draw do
  # resources :annotation_files
  post 'project/:user_name/:repo_name/items', to: 'items#create', as: 'create_item'
  get 'project/:user_name/:repo_name/items/new', to: 'items#new', as: 'new_item'
  get 'project/:user_name/:repo_name/items/:slug/edit', to: 'items#edit', as: 'edit_item'
  get 'project/:user_name/:repo_name/items/:slug', to: 'items#show', as: 'item'
  patch 'project/:user_name/:repo_name/items/:slug', to: 'items#update', as: 'update_item'
  delete 'project/:user_name/:repo_name/items/:slug', to: 'items#destroy', as: 'destroy_item'
  post 'project/:user_name/:repo_name/items/:slug/files', to: 'items#add_annotation_file', as: 'add_annotation_file'
  post 'project/:user_name/:repo_name/items/:slug/process', to: 'items#process_annotation_file', as: 'process_annotation_file'
  get 'project/:user_name/:repo_name/items/:slug/files/:layer/destroy', to: 'items#delete_annotation_layer', as: 'delete_annotation_layer', constraints: { layer: /[^\/]+/ }
  get 'project/:user_name/:repo_name/items/:slug/files/:file/download', to: 'items#download_annotation_file', as:  'download_annotation_file', constraints: { file: /[^\/]+/ }
  get 'project/:user_name/:repo_name/items/:slug/files/:file/configure', to: 'items#configure_annotation_file', as:  'configure_annotation_file', constraints: { file: /[^\/]+/ }
  get 'project/:user_name/:repo_name/items/import/new', to: 'items#new_import', as: 'new_import_item'
  post 'project/:user_name/:repo_name/items/import', to: 'items#import_manifest', as: 'import_manifest'


  post 'project/:user_name/:repo_name/pages', to: 'pages#create', as: 'create_page'
  get 'project/:user_name/:repo_name/pages/new', to: 'pages#new', as: 'new_page'
  get 'project/:user_name/:repo_name/pages/:slug/edit', to: 'pages#edit', as: 'edit_page'
  get 'project/:user_name/:repo_name/pages/:slug', to: 'pages#show', as: 'page'
  patch 'project/:user_name/:repo_name/pages/:slug', to: 'pages#update', as: 'update_page'
  delete 'project/:user_name/:repo_name/pages/:slug', to: 'pages#destroy', as: 'destroy_page'
  get 'project/:user_name/:repo_name/pages/:slug/move_up', to: 'pages#move_up', as: 'move_up_page'
  get 'project/:user_name/:repo_name/pages/:slug/move_down', to: 'pages#move_down', as: 'move_down_page'


  root to: 'project#all'

  get 'project/all', as: 'all_projects'
  get 'project/mine', as: 'my_projects'
  get 'project/:user_name/:repo_name', to: 'project#show', as: 'project'
  get 'project/new', to: 'project#new', as: 'new_project'
  post 'project', to: 'project#create', as: 'create_project'
  get 'project/:user_name/:repo_name/status', to: 'project#build_status', as: 'project_build_status'


  get 'user/login'
  get 'user/logout'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/auth/github/callback', to: 'user#login'
end
