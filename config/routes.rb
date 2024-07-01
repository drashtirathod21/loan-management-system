Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#welcome"

  resources :loans do
    member do
      patch :approve
      patch :reject
      patch :confirm_loan
      patch :reject_by_user
    end
  end
end
