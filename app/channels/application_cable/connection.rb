module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    def find_verified_user
      verify_user = User.find_by(email: ENV['CABLE_EMAIL'])
      if verify_user
        verify_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
