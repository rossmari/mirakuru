class Api::ContactsController < ApplicationController

  def index
    @contacts = Contact.all
    if params[:customer_id]
      @contacts = @contacts.where(customer_id: params[:customer_id])
    end
  end

  def check
    contact_exist = Contact.where(raw_value: Contact.clear_phone(params[:value])).any?
    render json: { uniq_value: !contact_exist }
  end

end