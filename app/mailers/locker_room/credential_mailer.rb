module LockerRoom
  class CredentialMailer < ActionMailer::Base
    layout 'locker_room/mailer'

    def reset_password_email(user)
      @user = user
      @url  = locker_room.password_recovery_url(
        :token => user.reset_password_token
      )
      mail(
        :to      => user.email,
        :subject => 'Your password has been reset'
      )
    end
  end
end
