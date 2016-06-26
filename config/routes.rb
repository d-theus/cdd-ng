Rails.application.routes.draw do
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

  root to: redirect('/blog/posts/recent')
end
