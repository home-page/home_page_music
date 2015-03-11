Rails.application.routes.draw do
  namespace :music do
    resources :year_in_reviews, only: [:index, :show] do
      member do
        get :top_albums
        get :top_songs
      end
    end
  end
  
  get 'music' => 'music/home#index', as: :music
end