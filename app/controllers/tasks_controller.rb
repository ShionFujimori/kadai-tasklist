class TasksController < ApplicationController
  
  before_action :require_user_logged_in, only: [:index, :show]
  
  include SessionsHelper
  
  def index
    if logged_in?
      @tasks = current_user.tasks.order(id: :desc).page(params[:page]).per(5)
    end
  end
  
  def show
    @task = current_user.tasks.find(params[:id])
  end
  
  def new
    @task = current_user.tasks.build
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が投稿されませんでした'
      render :new
    end
  end
  
  def edit
    @task = current_user.tasks.find(params[:id])
  end
  
  def update
    @task = current_user.tasks.find(params[:id])
    
    if @task.update(task_params)
      flash[:success] = 'Task が正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    
    flash[:success] = 'Taskは正常に削除されました'
    redirect_to tasks_url
  end
  
  private

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
end
