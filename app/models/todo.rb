class Todo < ApplicationRecord
    belongs_to :user
    validates_presence_of :name
    enum status: {
        incomplete: 0,
        complete: 1
    }

    private

    def send_assignment_email
        TodoMailer.todo_assigned(self).deliver_now
    end
end
