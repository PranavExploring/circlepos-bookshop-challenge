Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :books do
        member do
          post :sell
        end
      end
    end
  end
end
