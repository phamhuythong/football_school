Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # scope "(:locale)", locale: /en|vi/ do
  #   root to: 'welcome#index'
  # end

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  resources :stadium_groups, concerns: :paginatable
  resources :stadia, concerns: :paginatable
  resources :course_categories, concerns: :paginatable
  resources :courses, concerns: :paginatable do
    with_options module: :courses do
      resources :lessons
    end
  end
  resources :users, concerns: :paginatable
  resources :students, concerns: :paginatable do
    with_options module: :students do
      resources :student_courses
    end
  end
  resources :teachers, concerns: :paginatable

  root to: 'homes#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'auth/:provider/callback', to: 'authentications#create'
  get 'auth/failure', to: 'authentications#omniauth_failure'

  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  match '*unmatched', to: 'errors#route_not_found', via: :all
end
