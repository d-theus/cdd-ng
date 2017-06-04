class ContactMailer < ActionMailer::Base
  default from: "contact@cddevel.com"
  layout 'mailer'

  def contact_notification_email(contact)
    @contact = contact
    recipient = Admin.first
    mail to: recipient.email, subject: 'New Contact!'
  end
end
