require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    describe 'show' do
        let(:user) { create(:user) }

        before do
            allow(controller).to receive(:current_user).and_return(user)
        end

        it 'assigns the current user' do
            get :show
            expect(assigns(:user)).to eq(user)
        end
    end

    describe 'deseados' do
        let(:user) { create(:user) }
        let(:deseados) { [create(:product), create(:product)] }

        before do
            allow(controller).to receive(:current_user).and_return(user)
            allow(user).to receive(:deseados).and_return(deseados)
        end

        it 'assigns the desired products for the current user' do
            get :deseados
            expect(assigns(:deseados)).to eq(deseados)
        end
    end

    describe 'mensajes' do
        let(:user) { create(:user) }
        let(:messages) { [create(:message, user_id: user.id), create(:message, user_id: user.id)] }

        before do
            allow(controller).to receive(:current_user).and_return(user)
            allow(Message).to receive(:where).and_return(messages)
        end

        it 'assigns the messages for the current user' do
            get :mensajes
            expect(assigns(:user_messages)).to eq(messages)
        end

        it 'assigns an empty list of shown message ids' do
            get :mensajes
            expect(assigns(:shown_message_ids)).to eq([])
        end
    end

    describe '#actualizar_imagen' do
        let(:user) { create(:user) }
        let(:valid_image) { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test_image.jpg'), 'image/jpeg') }

        before do
            allow(controller).to receive(:current_user).and_return(user)
        end

        context 'when the image format is valid' do
            it 'updates the user image' do
                post :actualizar_imagen, params: { image: valid_image }
                expect(user.reload.image).to be_present
            end

            it 'sets a success flash notice' do
                post :actualizar_imagen, params: { image: valid_image }
                expect(flash[:notice]).to eq('Imagen actualizada correctamente')
            end
        end

        context 'when the image format is invalid' do
            it 'does not update the user image' do
                post :actualizar_imagen, params: { image: 'invalid_image' }
                expect(user.reload.image).not_to be_present
            end

            it 'sets an error flash message' do
                post :actualizar_imagen, params: { image: 'invalid_image' }
                expect(flash[:error]).to eq('Hubo un error al actualizar la imagen. Verifique que la imagen es de formato jpg, jpeg, png, gif o webp')
            end
        end
    end

    describe 'eliminar_deseado' do
        let(:user) { create(:user) }
        let(:product) { create(:product) }

        before do
            allow(controller).to receive(:current_user).and_return(user)
            user.deseados << product
        end

        it 'removes the desired product from the user wishlist' do
            post :eliminar_deseado, params: { deseados_id: product.id }
            expect(user.deseados).not_to include(product)
        end

        context 'when the product removal is successful' do
            it 'sets a success flash notice' do
                post :eliminar_deseado, params: { deseados_id: product.id }
                expect(flash[:notice]).to eq('Producto quitado de la lista de deseados')
            end
        end

        context 'when the product removal fails' do
            before do
                allow(user).to receive(:save).and_return(false)
            end

            it 'sets an error flash message' do
                post :eliminar_deseado, params: { deseados_id: product.id }
                expect(flash[:error]).to eq('Hubo un error al quitar el producto de la lista de deseados')
            end
        end
    end

end