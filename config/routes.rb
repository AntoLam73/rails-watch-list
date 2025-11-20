Rails.application.routes.draw do

  resources :lists do
    resources :bookmarks, only: [:new, :create, :destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check

end
