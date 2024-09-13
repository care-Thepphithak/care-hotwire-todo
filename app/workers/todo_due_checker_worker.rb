# app/workers/todo_due_checker_worker.rb
class TodoDueCheckerWorker
  include Sidekiq::Worker

  def perform
    # 0 is the status for incomplete 'todo'
    Todo.where('due_date < created_at AND status = ?', 0).find_each do |todo|
      TodoMailer.todo_passed_due_date(todo).deliver_later
    end
  end
end
