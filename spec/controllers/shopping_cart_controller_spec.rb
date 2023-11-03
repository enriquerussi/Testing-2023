require 'rails_helper'

RSpec.describe ShoppingCartController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:product) { FactoryBot.create(:product) }
  let(:shopping_cart) { FactoryBot.create(:shopping_cart, user: user) }

  describe 'GET show' do
    it 'returns http success when user is signed in' do
      sign_in user
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe 'details' do
    context 'when user is signed in' do
      let(:user) { create(:user) }
      let(:shopping_cart) { create(:shopping_cart, user_id: user.id) }

      before do
        allow(controller).to receive(:user_signed_in?).and_return(true)
        allow(controller).to receive(:current_user).and_return(user)
        allow(ShoppingCart).to receive(:find_by).with(user_id: user.id).and_return(shopping_cart)
      end

      it 'returns the total payment if products exist in the shopping cart' do
        allow(shopping_cart).to receive(:products).and_return({ '1' => 2, '2' => 1 }) # Change as per your data structure
        allow(shopping_cart).to receive(:precio_total).and_return(1000) # Change as per your scenario
        allow(shopping_cart).to receive(:costo_envio).and_return(500) # Change as per your scenario
        get :details
        expect(assigns(:total_pago)).to eq(1500) # Change as per your expected total payment
      end

      it 'redirects to /carro if no products are in the shopping cart' do
        allow(shopping_cart).to receive(:products).and_return({})
        get :details
        expect(flash[:alert]).to eq('No tienes productos que comprar.')
        expect(response).to redirect_to('/carro')
      end
    end

    context 'when user is not signed in' do
      it 'sets a flash alert and redirects back to root path' do
        allow(controller).to receive(:user_signed_in?).and_return(false)
        get :details
        expect(flash[:alert]).to eq('Debes iniciar sesión para comprar.')
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'insertar_producto' do
    let(:user) { create(:user) }
    let(:shopping_cart) { create(:shopping_cart, user_id: user.id) }
    let(:product) { FactoryBot.create(:product) }
    let(:add_product_params) { { amount: 2 } } # Change the parameters as per your data structure

    before do
      allow(controller).to receive(:user_signed_in?).and_return(true)
      allow(controller).to receive(:current_user).and_return(user)
      allow(ShoppingCart).to receive(:find_by).with(user_id: user.id).and_return(shopping_cart)
      allow(Product).to receive(:find).with(product.id.to_s).and_return(product)
    end

    context 'when product is added successfully to the shopping cart' do
      it 'redirects back to root path with a flash notice' do
        allow(shopping_cart).to receive(:products).and_return({ product.id.to_s => 1 })
        allow(shopping_cart).to receive(:update).and_return(true)
        post :insertar_producto, params: { product_id: product.id, add: add_product_params }
        expect(flash[:notice]).to eq('Producto agregado al carro de compras')
        expect(response).to redirect_to(root_path)
      end

      it 'redirects to /carro/detalle if buy_now is true' do
        allow(shopping_cart).to receive(:products).and_return({ product.id.to_s => 1 })
        allow(shopping_cart).to receive(:update).and_return(true)
        post :insertar_producto, params: { product_id: product.id, add: add_product_params, buy_now: true }
        expect(response).to redirect_to('http://test.host/')
      end
    end

    context 'when the product cannot be added to the shopping cart' do
      it 'redirects back to root path with a flash alert' do
        allow(shopping_cart).to receive(:products).and_return({ product.id.to_s => 100 })
        post :insertar_producto, params: { product_id: product.id, add: add_product_params }
        expect(flash[:alert]).to eq("El producto '#{product.nombre}' no tiene suficiente stock para agregarlo al carro de compras.")
        expect(response).to redirect_to(root_path)
      end

      it 'redirects back to root path with a flash alert if there is not enough stock' do
        allow(shopping_cart).to receive(:products).and_return({ product.id.to_s => product.stock.to_i + 1 })
        post :insertar_producto, params: { product_id: product.id, add: add_product_params }
        expect(flash[:alert]).to eq("El producto '#{product.nombre}' no tiene suficiente stock para agregarlo al carro de compras.")
        expect(response).to redirect_to(root_path)
      end

      it 'redirects back to root path with a flash alert if the product count in the shopping cart is more than 8' do
        allow(shopping_cart).to receive(:products).and_return({ '1' => 1, '2' => 1, '3' => 1, '4' => 1, '5' => 1, '6' => 1, '7' => 1, '8' => 1 })
        post :insertar_producto, params: { product_id: product.id, add: add_product_params }
        expect(flash[:alert]).to eq('Has alcanzado el máximo de productos en el carro de compras (8). Elimina productos para agregar más o realiza el pago de los productos actuales.')
        expect(response).to redirect_to(root_path)
      end

      it 'redirects to /carro if the user is not signed in' do
        allow(controller).to receive(:user_signed_in?).and_return(false)
        post :insertar_producto, params: { product_id: product.id, add: add_product_params }
        expect(flash[:alert]).to eq('Debes iniciar sesión para agregar productos al carro de compras.')
        expect(response).to redirect_to('/carro')
      end
    end
  end

  describe 'eliminar_producto' do
    let(:user) { create(:user) }
    let(:shopping_cart) { create(:shopping_cart, user_id: user.id) }
    let(:product) { create(:product) }

    before do
      allow(controller).to receive(:user_signed_in?).and_return(true)
      allow(controller).to receive(:current_user).and_return(user)
      allow(ShoppingCart).to receive(:find_by).with(user_id: user.id).and_return(shopping_cart)
      allow(Product).to receive(:find).with(product.id.to_s).and_return(product)
    end

    context 'when the product exists in the shopping cart' do
      it 'deletes the product from the shopping cart and redirects to /carro with a flash notice' do
        allow(shopping_cart).to receive(:products).and_return({ product.id.to_s => 1 })
        allow(shopping_cart).to receive(:update).and_return(true)
        delete :eliminar_producto, params: { product_id: product.id }
        expect(flash[:notice]).to eq('Producto eliminado del carro de compras')
        expect(response).to redirect_to('/carro')
      end

      it 'displays a flash alert if there was an error deleting the product' do
        allow(shopping_cart).to receive(:products).and_return({ product.id.to_s => 1 })
        allow(shopping_cart).to receive(:update).and_return(false)
        delete :eliminar_producto, params: { product_id: product.id }
        expect(flash[:alert]).to eq('Hubo un error al eliminar el producto del carro de compras')
        expect(response).to redirect_to('/carro')
      end
    end

    context 'when the product does not exist in the shopping cart' do
      it 'displays a flash alert and redirects to /carro' do
        allow(shopping_cart).to receive(:products).and_return({})
        delete :eliminar_producto, params: { product_id: product.id }
        expect(flash[:alert]).to eq('El producto no existe en el carro de compras')
        expect(response).to redirect_to('/carro')
      end
    end
  end

  describe 'realizar_compra' do
    let(:user) { create(:user) }
    let(:shopping_cart) { create(:shopping_cart, user_id: user.id) }

    before do
      allow(controller).to receive(:user_signed_in?).and_return(true)
      allow(controller).to receive(:current_user).and_return(user)
      allow(ShoppingCart).to receive(:find_by).with(user_id: user.id).and_return(shopping_cart)
    end

    context 'when the shopping cart is not found' do
      it 'displays a flash alert and redirects to /carro' do
        allow(ShoppingCart).to receive(:find_by).with(user_id: user.id).and_return(nil)
        get :realizar_compra
        expect(flash[:alert]).to eq('No se encontró tu carro de compras. Contacte un administrador.')
        expect(response).to redirect_to('/carro')
      end
    end

    context 'when there are no products in the shopping cart' do
      it 'displays a flash alert and redirects to /carro' do
        allow(shopping_cart).to receive_message_chain(:products, :count).and_return(0)
        get :realizar_compra
        expect(flash[:alert]).to eq('No tienes productos en el carro de compras')
        expect(response).to redirect_to('/carro')
      end
    end

    context 'when all requests are valid' do
      it 'clears the shopping cart, displays a flash notice, and redirects to /solicitud/index' do
        allow(controller).to receive(:comprobar_productos).with(shopping_cart).and_return(true)
        allow(controller).to receive(:crear_solicitudes).with(shopping_cart).and_return(true)
        allow(shopping_cart).to receive(:update).with(products: {}).and_return(true)
        get :realizar_compra
        expect(flash[:notice]).to eq('Compra realizada exitosamente')
        expect(response).to redirect_to('/solicitud/index')
      end
    end

    context 'when there is an error updating the shopping cart' do
      it 'displays a flash alert and redirects to /carro' do
        allow(controller).to receive(:comprobar_productos).with(shopping_cart).and_return(true)
        allow(controller).to receive(:crear_solicitudes).with(shopping_cart).and_return(true)
        allow(shopping_cart).to receive(:update).with(products: {}).and_return(false)
        get :realizar_compra
        expect(flash[:alert]).to eq('Hubo un error al actualizar el carro. Contacte un administrador.')
        expect(response).to redirect_to('/carro')
      end
    end
  end

  describe 'limpiar' do
    let(:user) { create(:user) }
    let(:shopping_cart) { create(:shopping_cart, user_id: user.id) }

    before do
      allow(controller).to receive(:user_signed_in?).and_return(true)
      allow(controller).to receive(:current_user).and_return(user)
      allow(ShoppingCart).to receive(:find_by).with(user_id: user.id).and_return(shopping_cart)
    end

    context 'when the shopping cart is found and successfully updated' do
      it 'empties the shopping cart, displays a flash notice, and redirects to /carro' do
        allow(shopping_cart).to receive(:update).with(products: {}).and_return(true)
        get :limpiar
        expect(flash[:notice]).to eq('Carro de compras limpiado exitosamente')
        expect(response).to redirect_to('/carro')
      end
    end

    context 'when there is an error updating the shopping cart' do
      it 'displays a flash alert and redirects to /carro' do
        allow(shopping_cart).to receive(:update).with(products: {}).and_return(false)
        get :limpiar
        expect(flash[:alert]).to eq('Hubo un error al limpiar el carro de compras. Contacte un administrador.')
        expect(response).to redirect_to('/carro')
      end
    end
  end

  describe 'add_product_params' do
    let(:params) { ActionController::Parameters.new(add: { amount: 2 }) }

    before { allow(controller).to receive(:params).and_return(params) }

    it 'permits the necessary parameters' do
      permitted_params = controller.send(:add_product_params).permit(:amount)
      expect(permitted_params).to eq(ActionController::Parameters.new(amount: 2).permit(:amount))
    end
  end

  describe 'address_params' do
    let(:params) do
      ActionController::Parameters.new(
        address: {
          nombre: 'John Doe',
          direccion: '123 Main St',
          comuna: 'Santiago',
          region: 'RM'
        }
      )
    end

    before { allow(controller).to receive(:params).and_return(params) }

    it 'permits the necessary parameters' do
      permitted_params = controller.send(:address_params).permit(:nombre, :direccion, :comuna, :region)
      expected_params = ActionController::Parameters.new(
      nombre: 'John Doe',
      direccion: '123 Main St',
      comuna: 'Santiago',
      region: 'RM'
    ).permit(:nombre, :direccion, :comuna, :region)
      expect(permitted_params).to eq(expected_params)
    end
  end

  describe 'crear_carro' do
    let(:current_user) { create(:user) }
    let(:params) { ActionController::Parameters.new }
    let(:controller) { described_class.new }

    before { allow(controller).to receive(:current_user).and_return(current_user) }
    before { allow(controller).to receive(:params).and_return(params) }

    context 'when shopping cart creation is successful' do
      it 'creates a new shopping cart and returns it' do
        expect(ShoppingCart).to receive(:new).and_return(ShoppingCart.new(user_id: current_user.id, products: {}))
        expect(controller.send(:crear_carro)).to be_an_instance_of(ShoppingCart)
      end
    end
  end

  describe 'comprobar_productos' do
    let(:current_user) { create(:user) }
    let(:shopping_cart) { create(:shopping_cart, user_id: current_user.id) }

    context 'when there is enough stock for all products' do
      it 'returns true' do
        product1 = create(:product, stock: 10)
        product2 = create(:product, stock: 15)
        shopping_cart.products = { product1.id => 5, product2.id => 10 }
        expect(controller.send(:comprobar_productos, shopping_cart)).to eq(true)
      end
    end

    context 'when there is not enough stock for some products' do
      it 'returns false and sets a flash alert message' do
        product1 = create(:product, stock: 10)
        product2 = create(:product, stock: 15)
        shopping_cart.products = { product1.id => 15, product2.id => 20 }
        allow(controller).to receive(:flash).and_return(alert: nil)
        expect(controller.send(:comprobar_productos, shopping_cart)).to eq(false)
        expect(controller.flash[:alert]).not_to be_nil
      end
    end
  end


  describe 'crear_solicitudes' do
    include Devise::Test::ControllerHelpers

    let(:current_user) { create(:user) }
    let(:shopping_cart) { create(:shopping_cart, user_id: current_user.id) }
    let(:controller) { ShoppingCartController.new }

    context 'when the requests are created successfully' do
      it 'returns true' do
        product1 = create(:product, stock: 10)
        product2 = create(:product, stock: 15)
        shopping_cart.products = { product1.id => 5, product2.id => 10 }
        allow(controller).to receive(:current_user).and_return(current_user)
        allow(controller).to receive(:flash).and_return(alert: nil) # Permitir cualquier llamada a flash
        expect(controller.send(:crear_solicitudes, shopping_cart)).to eq(true)
        expect(product1.reload.stock).to eq("5")
        expect(product2.reload.stock).to eq("5")
      end
    end
  end

end
