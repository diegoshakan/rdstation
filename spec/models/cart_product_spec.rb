require 'rails_helper'

RSpec.describe CartProduct, type: :model do
  context 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:product) }
  end

  context 'validations' do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end

  context 'total_price' do
    let(:product) { build(:product, price: 100) }
    let(:cart) { build(:cart) }
    let(:cart_product) { build(:cart_product, quantity: 2, product: product, cart: cart) }

    it 'returns the total price of the cart product' do
      expect(cart_product.total_price).to eq(cart_product.product.price * cart_product.quantity)
    end
  end
end
