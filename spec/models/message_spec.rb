require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "validations" do
    it { should validate_presence_of(:body) }
    
    it "validates presence of user_id" do
      message = Message.new(body: "Example Body", user_id: nil, product_id: 1)
      message.valid?
      expect(message.errors[:user_id]).to include("can't be blank")
    end

    it { should validate_presence_of(:product_id) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:product) }
  end
end
