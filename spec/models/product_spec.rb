require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "validations" do
    it { should validate_presence_of(:categories) }
    it { should validate_inclusion_of(:categories).in_array(['Cancha', 'Accesorio tecnologico', 'Accesorio deportivo', 'Accesorio de vestir', 'Accesorio de entrenamiento', 'Suplementos', 'Equipamiento']) }

    it { should validate_presence_of(:nombre) }

    it { should validate_presence_of(:stock) }
    it { should validate_numericality_of(:stock).is_greater_than_or_equal_to(0) }

    it { should validate_presence_of(:precio) }
    it { should validate_numericality_of(:precio).is_greater_than_or_equal_to(0) }

    it { should validate_presence_of(:user_id) }

    it { should validate_numericality_of(:stock).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:precio).is_greater_than_or_equal_to(0) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_one_attached(:image) }
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:messages).dependent(:destroy) }
    it { should have_many(:solicituds).dependent(:destroy) }
  end
end
