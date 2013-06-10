ProcessCsvWithResque::Application.routes.draw do
  root to: 'clients#index'
  resources :clients do
    post :create_by_csv, on: :collection
  end
  mount Resque::Server, at: "/resque"
end
