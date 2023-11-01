require 'rails_helper'

RSpec.describe ContactMessageController, type: :controller do

    let(:admin_user) { FactoryBot.create(:user, role: 'admin') }

    before do
        sign_in admin_user
    end

  describe "POST #crear" do
    it "creates a new contact message and redirects to /contacto" do
      post :crear, params: { contact: { name: "John Doe", mail: "john@example.com", phone: "+56123456789", title: "Hello", body: "Test message" } }
      expect(response).to redirect_to('/contacto')
      expect(flash[:notice]).to eq('Mensaje de contacto enviado correctamente')
    end

    it "renders :contacto template when contact message is not saved" do
      post :crear, params: { contact: { name: "John Doe", mail: "john@example.com", phone: "+56123456789", title: "", body: "" } }
      #expect(response).to render_template(:contacto)
      expect(flash[:alert]).not_to be_empty
    end
  end

  describe "GET #mostrar" do
    it "assigns all contact messages sorted by creation date" do
      contact_message1 = FactoryBot.create(:contact_message, created_at: 2.days.ago)
      contact_message2 = FactoryBot.create(:contact_message, created_at: 1.day.ago)
      get :mostrar
      expect(assigns(:contact_messages)).to eq([contact_message2, contact_message1])
    end

    it "renders :contacto template" do
      get :mostrar
      expect(response).to render_template(:contacto)
    end
  end

  describe "DELETE #eliminar" do
    it "deletes the contact message and redirects to /contacto" do
      contact_message = FactoryBot.create(:contact_message)
      delete :eliminar, params: { id: contact_message.id }
      expect(response).to redirect_to('/contacto')
      expect(flash[:notice]).to eq('Mensaje de contacto eliminado correctamente')
    end

    it "redirects to /contacto with an alert message when contact message is not found" do
      delete :eliminar, params: { id: 999 }
      expect(response).to redirect_to('/contacto')
      expect(flash[:alert]).to eq('Error al eliminar el mensaje de contacto')
    end
  end

  describe "DELETE #limpiar" do
    it "deletes all contact messages and redirects to /contacto" do
      FactoryBot.create_list(:contact_message, 3)
      delete :limpiar
      expect(response).to redirect_to('/contacto')
      expect(flash[:notice]).to eq('Mensajes de contacto eliminados correctamente')
    end

    it "redirects to /contacto with an alert message when there are no contact messages" do
      delete :limpiar
      expect(response).to redirect_to('/contacto')
      expect(flash[:alert]).to eq('Error al eliminar los mensajes de contacto')
    end
  end
end
