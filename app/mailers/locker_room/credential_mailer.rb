module LockerRoom
  class CredentialMailer < ActionMailer::Base
    layout 'locker_room/mailer'

    def reset_password_email(user)
      @user = user
      attrs = {
        :token => user.reset_password_token
      }
      @url = locker_room.edit_password_recovery_url(attrs)
      mail to: user.email, subject: 'Your password has been reset'
    end
  end
end
