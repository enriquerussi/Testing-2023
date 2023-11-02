require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'index' do
    let! (:product1) { FactoryBot.create(:product, nombre: 'Product A', categories: 'Cancha') }
    let! (:product2) { FactoryBot.create(:product, nombre: 'Product B', categories: 'Accesorio tecnologico') }
    

    context 'when both category and search parameters are present' do
      it 'returns the products with the specified category and name' do
        get :index, params: { category: 'Cancha', search: 'Product A' }
        expect(assigns(:products)).to match_array([product1])
      end
    end

    context 'when only the category parameter is present' do
      it 'returns the products with the specified category' do
        get :index, params: { category: 'Accesorio tecnologico' }
        expect(assigns(:products)).to match_array([product2])
      end
    end

    context 'when only the search parameter is present' do
      it 'returns the products with the specified name' do
        get :index, params: { search: 'Product B' }
        expect(assigns(:products)).to match_array([product2])
      end
    end

    context 'when neither category nor search parameters are present' do
      it 'returns all products' do
        get :index
        expect(assigns(:products)).to match_array([product1, product2])
      end
    end
  end

  describe 'leer' do
    

    let! (:product) { FactoryBot.create(:product, nombre: 'Product A', horarios: 'Monday,Tuesday;Wednesday,Thursday') }
    let!(:review1) { FactoryBot.create(:review, product: product, calification: 3) }
    let!(:review2) { FactoryBot.create(:review, product: product, calification: 4) }

    context 'when product has reviews' do
      it 'assigns the correct instance variables' do
        get :leer, params: { id: product.id }
        expect(assigns(:product)).to eq(product)
        expect(assigns(:reviews)).to match_array([review1, review2])
        expect(assigns(:calification_mean)).to eq(3.5)
      end
    end

    context 'when product has no reviews' do
      it 'assigns the correct instance variables' do
        product.reviews.destroy_all
        get :leer, params: { id: product.id }
        expect(assigns(:product)).to eq(product)
        expect(assigns(:reviews)).to be_empty
        expect(assigns(:calification_mean)).to be_nil
      end
    end

    context 'when product has horarios' do
      it 'assigns the correct instance variable' do
        get :leer, params: { id: product.id }
        expect(assigns(:horarios)).to eq([['Monday', 'Tuesday'], ['Wednesday', 'Thursday']])
      end
    end

    context 'when product has no horarios' do
      it 'assigns nil to the horarios instance variable' do
        product.update(horarios: nil)
        get :leer, params: { id: product.id }
        expect(assigns(:horarios)).to be_nil
      end
    end
  end

  describe "GET crear" do
    it 'assigns a new product as @product' do
      get :crear
      expect(assigns(:product)).to be_nil
    end
  end

  describe 'insert_deseado' do
    let(:user) { User.create(name: 'Test User', email: 'test@example.com', password: 'password') }

    context 'when current_user does not have any deseados' do
      it 'adds the product to the user deseados list' do
        allow(controller).to receive(:current_user).and_return(user)
        post :insert_deseado, params: { product_id: 1 }
        expect(user.deseados).to eq(['1'])
      end
    end

    context 'when current_user already has deseados' do
      it 'appends the product to the existing user deseados list' do
        user.update(deseados: ['1'])
        allow(controller).to receive(:current_user).and_return(user)
        post :insert_deseado, params: { product_id: 2 }
        expect(user.deseados).to match_array(['1', '2'])
      end
    end

    context 'when current_user saves successfully' do
      it 'sets a success flash message' do
        allow(controller).to receive(:current_user).and_return(user)
        allow(user).to receive(:save).and_return(true)
        post :insert_deseado, params: { product_id: 1 }
        expect(flash[:notice]).to eq('Producto agregado a la lista de deseados')
      end
    end

    context 'when current_user fails to save' do
      it 'sets an error flash message' do
        allow(controller).to receive(:current_user).and_return(user)
        allow(user).to receive(:save).and_return(false)
        allow(user).to receive_message_chain(:errors, :full_messages, :join).and_return('Error message')
        post :insert_deseado, params: { product_id: 1 }
        expect(flash[:error]).to eq('Hubo un error al guardar los cambios: Error message')
      end
    end
  end

  describe 'insertar' do
    let(:admin_user) { User.create(name: 'Admin User', email: 'admin@example.com', password: 'password', role: 'admin') }
    let(:regular_user) { User.create(name: 'Regular User', email: 'user@example.com', password: 'password') }

    context 'when current_user is an admin' do
      it 'creates a product and sets a success flash message' do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow(admin_user).to receive(:save).and_return(true)
        post :insertar, params: { product: { nombre: 'Test Product', precio: 10, stock: 5, categories: 'Cancha' } }
        expect(flash[:notice]).to eq('Producto creado Correctamente !')
      end
    end

    context 'when current_user is not an admin' do
      it 'sets an alert flash message' do
        allow(controller).to receive(:current_user).and_return(regular_user)
        post :insertar, params: { product: { nombre: 'Test Product', precio: 10, stock: 5, categories: 'Test' } }
        expect(flash[:alert]).to eq('Debes ser un administrador para crear un producto.')
      end
    end

    context 'when product fails to save' do
      it 'sets an error flash message and redirects to crear path' do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow_any_instance_of(Product).to receive(:save).and_return(false)
        allow_any_instance_of(Product).to receive_message_chain(:errors, :full_messages, :join).and_return('Error message')
        post :insertar, params: { product: { nombre: 'Test Product', precio: 10, stock: 5, categories: 'Test' } }
        expect(flash[:error]).to eq('Hubo un error al guardar el producto: Error message')
      end
    end
  end

  describe "GET actualizar" do
    it "returns http success" do
      user = FactoryBot.create(:user, role: 'admin')
      sign_in user
      product = FactoryBot.create(:product)
      get :actualizar, params: { id: product.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'actualizar_producto' do
    let(:admin_user) { FactoryBot.create(:user, name: 'Admin User', email: 'admin@example.com', password: 'password', role: 'admin') }
    let(:regular_user) { FactoryBot.create(:user, name: 'Regular User', email: 'user@example.com', password: 'password') }
    let!(:product) { FactoryBot.create(:product, nombre: 'Test Product', precio: 10, stock: 5, categories: 'Cancha') }

    context 'when current_user is an admin' do
      it 'updates the product and redirects to index' do
        allow(controller).to receive(:current_user).and_return(admin_user)
        patch :actualizar_producto, params: { id: product.id, product: { nombre: 'Updated Product', precio: 20, stock: 10, categories: 'Accesorio tecnologico' } }
        expect(response).to redirect_to('/products/index')
      end
    end

    context 'when current_user is not an admin' do
      it 'sets an alert flash message' do
        allow(controller).to receive(:current_user).and_return(regular_user)
        patch :actualizar_producto, params: { id: product.id, product: { nombre: 'Updated Product', precio: 20, stock: 10, categories: 'Accesorio tecnologico' } }
        expect(flash[:alert]).to eq('No estás autorizado para acceder a esta página')
      end
    end

    context 'when product fails to update' do
      it 'sets an error flash message and redirects to actualizar path' do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow_any_instance_of(Product).to receive(:update).and_return(false)
        patch :actualizar_producto, params: { id: product.id, product: { nombre: 'Updated Product', precio: 20, stock: 10, categories: 'Updated' } }
        expect(flash[:error]).to eq('Hubo un error al guardar el producto. Complete todos los campos solicitados!')
        expect(response).to redirect_to("/products/actualizar/#{product.id}")
      end
    end
  end

  describe 'eliminar' do
    let(:admin_user) { User.create(name: 'Admin User', email: 'admin@example.com', password: 'password', role: 'admin') }
    let(:regular_user) { User.create(name: 'Regular User', email: 'user@example.com', password: 'password') }
    let!(:product) { FactoryBot.create(:product, nombre: 'Test Product', precio: 10, stock: 5, categories: 'Cancha') }

    context 'when current_user is an admin' do
      it 'destroys the product and redirects to index' do
        allow(controller).to receive(:current_user).and_return(admin_user)
        delete :eliminar, params: { id: product.id }
        expect(Product.exists?(product.id)).to be_falsey
        expect(response).to redirect_to('/products/index')
      end
    end

    context 'when current_user is not an admin' do
      it 'sets an alert flash message' do
        allow(controller).to receive(:current_user).and_return(regular_user)
        delete :eliminar, params: { id: product.id }
        expect(flash[:alert]).to eq('No estás autorizado para acceder a esta página')
        expect(response).to redirect_to('http://test.host/')
      end
    end
  end

  describe 'parametros' do
    let(:valid_params) do
      ActionController::Parameters.new(
        product: {
          nombre: 'Test Product',
          precio: 10,
          stock: 5,
          categories: 'Cancha',
          horarios: 'Monday-Friday'
        }
      )
    end
  
    it 'requires and permits the expected parameters' do
      allow(controller).to receive(:params).and_return(valid_params)
      expect(controller.send(:parametros)).to eq(
        ActionController::Parameters.new({
          'nombre' => 'Test Product',
          'precio' => 10,
          'stock' => 5,
          'categories' => 'Cancha',
          'horarios' => 'Monday-Friday'
        }).permit(:nombre, :precio, :stock, :image, :categories, :horarios)
      )
    end

    it 'requires product parameters' do
      expect { controller.send(:parametros) }.to raise_error(ActionController::ParameterMissing)
    end
  end
end

