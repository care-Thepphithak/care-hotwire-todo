class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy change_status ]

  def change_status
    @todo.update(status: todo_params[:status])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@todo)}_container") }
      format.html { redirect_to todos_path, notice: "Updated todo status." }
    end
    broadcast_todo_change
  end
  # GET /todos or /todos.json
  def index
    Rails.logger.info 'Index view accessed'
    @todos = Todo.where(status: params[:status].presence || 'incomplete').order(created_at: :desc)
  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
  end

  # DELETE /todos/reset
  # destroy_all
  def destroy_all
    Todo.destroy_all
    broadcast_todo_change
    respond_to do |format|
      format.html { redirect_to todos_url, notice: "Todo was successfully reseted." }
    end
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        broadcast_todo_change
        Rails.logger.info 'Create new todo #'
        format.turbo_stream
        format.html { redirect_to todo_url(@todo), notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@todo)}_form", partial: "form", locals: { todo: @todo }) }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        broadcast_todo_change
        format.turbo_stream
        format.html { redirect_to todo_url(@todo), notice: "Todo was successfully updated." }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@todo)}_form", partial: "form", locals: { todo: @todo }) }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy!
    broadcast_todo_change
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@todo)}_container") }
      format.html { redirect_to todos_url, notice: "Todo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def broadcast_todo_change
    todos = Todo.all.order(created_at: :desc)
    incomplete_todos, completed_todos = todos.partition { |todo| todo.status == 'incomplete' }
    incomplete_todos_html = render_to_string(partial: 'todos/todo', collection: incomplete_todos)
    completed_todos_html = render_to_string(partial: 'todos/todo', collection: completed_todos)
    ActionCable.server.broadcast 'todo_channel', { incomplete: incomplete_todos_html, complete: completed_todos_html }
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:name, :status, :due_date, :user_id)
    end
end
