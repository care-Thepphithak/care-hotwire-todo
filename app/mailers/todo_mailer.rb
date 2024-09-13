class TodoMailer < ApplicationMailer

  def todo_assigned(todo)
    Rails.logger.info "Sending email to #{todo.user.email}"
    @todo = todo
    @user = todo.user
    mail(to: @user.email, subject: 'You have been assigned a new Todo')
  end

  def todo_passed_due_date(todo)
    Rails.logger.info "Sending email to #{todo.user.email}"
    @todo = todo
    @user = todo.user
    mail(to: @user.email, subject: 'Your Todo has passed its due date :(')
  end
end
