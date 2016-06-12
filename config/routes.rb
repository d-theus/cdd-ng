Rails.application.routes.draw do
  scope :blog do
    get '/', to: redirect('/blog/posts')
    resources :posts do
      get :preview, on: :collection
    end
    resources :pictures, except: [:show, :new, :edit], controller: :pictures
  end

  root to: redirect('/blog/posts')
end
