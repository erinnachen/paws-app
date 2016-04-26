Rails.application.routes.draw do
  root to: "dashboard#show"

  get "/auth/google_oauth2", as: "google_login"
  get "/auth/google_oauth2/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"

  resources :dog_images, only: [:new, :create, :show, :update] do
    member do
      get "/analysis", to: "dog_images#analysis"
      get "/report", to: "dog_images#report"
      patch "/result", to: "dog_images#update_result"
      patch "/wrong_result", to: "dog_images#update_wrong_result"
    end
  end

  get "/charts/top_breeds/:id", to: "charts#top_breeds", defaults: {format: :json}
end
