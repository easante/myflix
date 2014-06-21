class WelcomeMailer < ActionMailer::Base
  def notify_on_sign_up(user)
    @user = user

    mail from: 'Emmanuel Asante <esante2011@gmail.com>',
           to: user.email,
      subject: 'MyFlix Sign up'
  end

  def send_password_link(user)
    @user = user

    mail from: 'Emmanuel Asante <esante2011@gmail.com>',
           to: user.email,
      subject: 'Reset Password'
  end

  def send_invitation_link(invitation)
    @invitation = invitation

    mail from: 'Emmanuel Asante <esante2011@gmail.com>',
           to: invitation.email,
      subject: 'Invitation to sign up'
  end
end
