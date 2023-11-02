require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'index' do
    it 'renders the index template' do
      get :index
    end
  end
end