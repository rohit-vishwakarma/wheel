# frozen_string_literal: true

class Api::V1::ContactsController < Api::V1::BaseController
  before_action :load_contact, only: [:show, :delete]

  def index
    contacts = current_user.contacts
    render json: { contacts: contacts }
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.valid?
      Mailer.contact_email(@contact.title, @contact.email, @contact.body).deliver_later
      render json: { message: "Thank you for your message. We will contact you soon!" }
    else
      render json: { error: @contact.errors.full_messages.to_sentence }, status: 422
    end
  end

  private

    def contact_params
      params.require(:contact).permit([ :email, :title, :body]).to_h
    end

    def load_contact
      @contact = Contact.find(params[:id])
    end
end
