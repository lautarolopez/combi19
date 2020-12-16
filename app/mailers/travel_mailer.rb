class TravelMailer < Devise::Mailer
    helper :application 
    include Devise::Controllers::UrlHelpers
    default template_path: 'devise/mailer'

    def refund_mail(user, travels, percentage, amount)
        @user = user
        @travels = travels
        @amount = amount
        @percentage = percentage
        if @travels.size == 1
            s = ""
        else 
            s = "s"
        end
        mail(to: @user.email, from: "combidiecinueve@gmail.com" ,subject: "Cancelación de viaje" + s)
    end

    def contact_mail(name, email, message)
        @name = name
        @email = email
        @message = message
        mail(to: "combidiecinueve@gmail.com", from: "combidiecinueve@gmail.com", subject: "Combi19 | Nuevo mensaje")
    end
end
