Rails.application.routes.draw do
  resources :contacts, except: [:edit, :show]
  resource  :portfolio, only: [:show], controller: :portfolio
  resources :works, only: [:new, :edit, :update, :create, :destroy], controller: :portfolio

  devise_for :admins
  scope :blog do
    get '', to: redirect('/blog/posts/recent')
    resources :posts do
      collection do
        get '', to: redirect('/blog/posts/recent')
        get 'recent', action: :index, as: :recent, defaults: { scope: :recent }
        get 'search', action: :index, as: :search, defaults: { scope: :search }
        get 'tagged/:tag', action: :index, as: :tagged, defaults: { scope: :tagged }
        get 'preview'
      end
      resources :comments
    end
    resources :pictures, except: [:show, :new, :edit], controller: :pictures
  end

  get '/about', to: 'about#show', as: 'about'
  root to: 'posts#index'
end
