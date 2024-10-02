class TodoChannel < ApplicationCable::Channel
  def subscribed
    stream_from "todo_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def retrieve_todos
    ActionCable.server.broadcast 'todo_channel', { todos: Todo.all }
  end
end
