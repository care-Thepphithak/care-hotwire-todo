class TodoChannel < ApplicationCable::Channel
  def subscribed
    stream_from "todo_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
