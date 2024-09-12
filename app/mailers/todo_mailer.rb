class TodoMailer < ApplicationMailer

  def todo_assigned(todo)
    Rails.logger.info "Sending email to #{todo.user.email}"
    @todo = todo
    @user = todo.user
    mail(to: @user.email, subject: 'You have been assigned a new Todo')
  end
end
