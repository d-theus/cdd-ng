Rails.application.routes.draw do
  resources :contacts, except: [:edit, :show]
  resource  :portfolio, only: [:show], controller: :portfolio
  resources :works, only: [:new, :edit, :update, :create, :destroy], controller: :portfolio

  devise_for :admins
  scope :blog do
    get '/', to: redirect('/blog/posts/recent')
    resources :posts do
      get '', on: :collection, to: redirect('/blog/posts/recent')
      get :preview, on: :collection
      get :recent, on: :collection, action: :index
      get 'tagged/:tag', on: :collection, action: :tagged, as: :tagged
    end
    resources :pictures, except: [:show, :new, :edit], controller: :pictures
  end

  get '/about', to: 'about#show', as: 'about'
  root to: redirect('/blog/posts/recent')
end
