class ContactMailer < ApplicationMailer
  def contact_mail(contact)
    @contact = contact
    if @contact.no_reply
      mail to: 'infopopknock@gmail.com', subject: '[返信不要]お問い合わせ'
    else
      mail to: 'infopopknock@gmail.com', subject: 'お問い合わせ'
    end
  end
end
