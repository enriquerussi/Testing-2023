require 'rails_helper'

RSpec.describe ContactMessage, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(50) }
    
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_most(500) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }

    it { should validate_presence_of(:mail) }
    it { should validate_length_of(:mail).is_at_most(50) }
    it { should allow_value('example@example.com').for(:mail) }
    it { should_not allow_value('invalid_email').for(:mail) }

    it { should validate_length_of(:phone).is_at_most(20) }
    it { should_not allow_value('invalid_phone').for(:phone) }
    it { should allow_value('+56912345678').for(:phone) }
  end
end
