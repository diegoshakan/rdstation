class Cart < ApplicationRecord
  has_many :cart_products, dependent: :destroy

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  def total_price
    cart_products.sum(&:total_price)
  end

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado
end
