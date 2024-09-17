class Todo < ApplicationRecord
    belongs_to :user
    validates_presence_of :name
    enum :status, { incomplete: 0, complete: 1 }


    after_create :send_assignment_email

    private

    def send_assignment_email
        TodoMailer.todo_assigned(self).deliver_later
    end
end
