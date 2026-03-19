class TasksController < ApplicationController
  before_action :set_user
  before_action :set_task, only: [ :show, :update, :destroy ]


  def index
    current_scope = current_user.tasks
    filtered = TaskFilter.new(current_scope, query_params).apply
    sorted = TaskSorter.new(filtered, query_params).apply

    @tasks = sorted.page(page).per(per_page)
    render json: @tasks, each_serializer: TaskSerializer, meta: pagination_meta(@tasks), status: :ok
  end

  def show
    render json: @task, serializer: TaskDetailSerializer, status: :ok
  end

  def create
    @task = @user.tasks.build(task_params)
    @task.save!
    NotifyOnTaskCreateJob.perform_later(@task.id)
    render json: @task, serializer: TaskDetailSerializer, status: :created
  end

  def update
    @task.update!(task_params)
    render json: @task, serializer: TaskDetailSerializer, status: :ok
  end

  def destroy
    @task.destroy
    render json: { message: "Task deleted successfully" }, status: :ok
  end

  private

  def set_user
    @user = current_user
  end
  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :due_date)
  end

  def page
    (request.headers["X-Page"] || params[:page] || 1).to_i
  end

  def per_page
    per = (params[:per_page] || Kaminari.config.default_per_page).to_i
    per.clamp(1, Kaminari.config.max_per_page)
  end

  def query_params
    params.permit(
      :search,
      :sort_by,
      :sort_dir,
      :priority,
      status: []
    )
  end
end
