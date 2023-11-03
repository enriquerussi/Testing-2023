require 'rails_helper'

RSpec.describe SolicitudController, type: :controller do
  describe 'index' do
    let(:current_user) { create(:user) }

    it 'assigns the correct requests and products' do
      solicitud1 = create(:solicitud, user_id: current_user.id)
      solicitud2 = create(:solicitud, user_id: current_user.id)
      producto1 = create(:product, user_id: current_user.id)
      producto2 = create(:product, user_id: current_user.id)

      get :index

      expect(assigns(:solicitudes)).to match_array([solicitud1, solicitud2])
      expect(assigns(:productos)).to match_array([producto1, producto2])
    end
  end

  describe 'insertar' do
    let(:current_user) { create(:user) }
    let(:product) { create(:product) }

    it 'creates a new purchase request' do
      solicitud_params = { solicitud: { stock: 5, reservation_datetime: DateTime.now } }

      post :insertar, params: { product_id: product.id, solicitud: solicitud_params }

      solicitud = Solicitud.last

      expect(solicitud).to be_present
      expect(solicitud.status).to eq('Pendiente')
      expect(solicitud.stock).to eq(5)
      expect(solicitud.product_id).to eq(product.id)
      expect(solicitud.user_id).to eq(current_user.id)
    end
  end

  describe 'eliminar' do
    let(:current_user) { create(:user) }
    let(:product) { create(:product) }
    let(:solicitud) { create(:solicitud, product_id: product.id, user_id: current_user.id, stock: 5) }

    it 'deletes the purchase request' do
      delete :eliminar, params: { id: solicitud.id }

      expect(response).to redirect_to('/solicitud/index')
      expect(flash[:notice]).to eq('Solicitud eliminada correctamente!')
      expect(Product.find(product.id).stock).to eq(5)
    end
  end

  describe 'actualizar' do
    let(:current_user) { create(:user) }
    let(:solicitud) { create(:solicitud, user_id: current_user.id) }

    it 'updates the status of the purchase request to "Aprobada"' do
      patch :actualizar, params: { id: solicitud.id, status: 'Aprobada' }

      expect(response).to redirect_to('/solicitud/index')
      expect(flash[:notice]).to eq('Solicitud aprobada correctamente!')
      expect(Solicitud.find(solicitud.id).status).to eq('Aprobada')
    end
  end

  describe 'parametros' do
    let(:product_id) { 1 }
    let(:params) { ActionController::Parameters.new(solicitud: { stock: 5, reservation_datetime: '2023-11-01 12:00:00' }).merge(product_id: product_id) }

    it 'permits the required parameters' do
      permitted_params = controller.send(:parametros)
      expect(permitted_params).to eq(ActionController::Parameters.new({ stock: 5, reservation_datetime: '2023-11-01 12:00:00', product_id: '1' }))
    end
  end
end