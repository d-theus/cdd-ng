class PortfolioController < ApplicationController
  before_action :authenticate, except: [:show]
  before_action :fetch_work, only: [:edit, :update, :destroy]

  def new
    @work = Work.new
  end

  def edit
  end

  def create
    @work = Work.new(work_params)
    if @work.save
      redirect_to portfolio_path
    else
      flash.now[:alert] = 'Cannot create work.'
      render :new
    end
  end

  def update
    if @work.update_attributes(work_params)
      redirect_to portfolio_path
    else
      flash.now[:alert] = 'Cannot update work.'
      render :edit
    end
  end

  def show
    @works = WorkListDecorator.new(Work.all, view_context)
  end

  def destroy
    if Work.destroy(params[:id])
      redirect_to portfolio_path
    else
      flash.now[:alert] = 'Cannot destroy work.'
      render :edit
    end
  end

  private

  def fetch_work
    @work = Work.find(params[:id])
  end

  def work_params
    params.require(:work).permit(:title, :description, :website_link, :github_link, :image)
  end
end
