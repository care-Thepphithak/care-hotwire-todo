class TodoMailer < ApplicationMailer
  default from: 'todo@dds.gom'

  def todo_assigned(todo)
    @todo = todo
    @user = todo.user
    mail(to: @user.email, subject: 'You have been assigned a new Todo')
  end
end
