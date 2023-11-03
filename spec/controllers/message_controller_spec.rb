require 'rails_helper'

RSpec.describe MessageController, type: :controller do
    let(:user) { FactoryBot.create(:user) }
    let(:product) { FactoryBot.create(:product) }
    let(:valid_attributes) { FactoryBot.attributes_for(:message, product_id: product.id) }
  
    before do
      sign_in user
    end
  
    describe "POST insertar" do
      it "creates a new message and redirects to product page" do
        expect {
          post :insertar, params: { product_id: product.id, message: valid_attributes }
        }.to change(Message, :count).by(1)
        expect(response).to redirect_to("/products/leer/#{product.id}")
        expect(flash[:notice]).to eq('Pregunta creada correctamente!')
      end
  
      it "redirects to product page with error if message creation fails" do
        post :insertar, params: { product_id: product.id, message: { body: nil } }
        expect(response).to redirect_to("/products/leer/#{product.id}")
        expect(flash[:error]).to eq('Hubo un error al guardar la pregunta. ¡Completa todos los campos solicitados!')
      end
    end
  
    describe "DELETE eliminar" do
      let!(:message) { FactoryBot.create(:message, product: product) }
  
      it "deletes the message and redirects to product page" do
        expect {
          delete :eliminar, params: { product_id: product.id, message_id: message.id }
        }.to change(Message, :count).by(-1)
        expect(response).to redirect_to("/products/leer/#{product.id}")
      end
    end

    describe 'parametros' do
      let(:params) { { product_id: 1, message: { body: 'Test Body', ancestry: nil } } }
      let(:controller) { described_class.new }

      it 'permits and merges the correct parameters' do
        allow(controller).to receive(:params).and_return(params)
        permitted_params = controller.send(:parametros)
        expect(permitted_params[:body]).to eq('Test Body')
        expect(permitted_params[:ancestry]).to eq(nil)
        expect(permitted_params[:product_id]).to eq('1') 
      end
    end
  end