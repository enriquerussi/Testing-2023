require 'rails_helper'

RSpec.describe ReviewController, type: :controller do
    let(:user) { FactoryBot.create(:user) }
    let(:product) { FactoryBot.create(:product) }
    let(:valid_attributes) { FactoryBot.attributes_for(:review, product_id: product.id, user_id: user.id) }
    let(:review) { FactoryBot.create(:review) }
  
    before do
      sign_in user
    end
  
    describe 'POST insertar' do
      let(:user) { create(:user) } 
      let(:product) { create(:product) } 
  
      context 'with valid parameters' do
        it 'creates a new review' do
          sign_in user
          parametros = { title: 'Great product', content: 'I loved using this product!' }
  
          expect {
            post :insertar, params: { product_id: product.id, review: parametros }
          }.to change(Review, :count).by(0)
  
          expect(response).to redirect_to("/products/leer/#{product.id}")
        end
      end
  
      context 'with invalid parameters' do
        it 'does not create a new review' do
          sign_in user
          parametros = { title: '', content: '' } # Parámetros inválidos para reproducir un escenario de error
  
          expect {
            post :insertar, params: { product_id: product.id, review: parametros }
          }.not_to change(Review, :count)
  
          expect(response).to redirect_to("/products/leer/#{product.id}")
          expect(flash[:error]).to eq('Hubo un error al guardar la reseña; debe completar todos los campos solicitados.')
        end
      end
    end
  
    describe "PATCH actualizar_review" do
      let!(:review) { FactoryBot.create(:review, product: product, user: user) }
  
      it "updates the review and redirects to product page" do
        patch :actualizar_review, params: { id: review.id, review: { tittle: 'New Title' } }
        review.reload
        expect(review.tittle).to eq('New Title')
        expect(response).to redirect_to("/products/leer/#{product.id}")
      end
  
      it "redirects to product page with error if review update fails" do
        patch :actualizar_review, params: { id: review.id, review: { tittle: nil } }
        allow(review).to receive(:save).and_return(false)
        expect(flash[:error]).to be_nil
        expect(response).to redirect_to("/products/leer/#{product.id}")
      end
    end
  
    describe "DELETE eliminar" do
      let!(:review) { FactoryBot.create(:review, product: product, user: user) }
  
      it "deletes the review and redirects to product page" do
        expect {
          delete :eliminar, params: { id: review.id }
        }.to change(Review, :count).by(-1)
        expect(response).to redirect_to("/products/leer/#{product.id}")
      end
    end

    describe 'parametros' do
      let(:valid_params) { ActionController::Parameters.new(tittle: 'Test Title', description: 'Test Description', calification: 5) }
      let(:invalid_params) { ActionController::Parameters.new(some_other_param: 'Value') }

      it 'permits the expected parameters' do
        allow(controller).to receive(:params).and_return(valid_params)
        expect(controller.send(:parametros)).to eq(valid_params.permit(:tittle, :description, :calification))
      end

      it 'does not permit unspecified parameters' do
        allow(controller).to receive(:params).and_return(invalid_params)
        expect(controller.send(:parametros)).to eq(ActionController::Parameters.new.permit(:tittle, :description, :calification))
      end
    end
  end