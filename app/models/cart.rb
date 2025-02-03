class Cart < ApplicationRecord
  after_touch :update_last_interaction_at
  has_many :cart_products, dependent: :destroy

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  def total_price
    cart_products.sum(&:total_price)
  end

  def abandoned?
    abandoned_at.present?
  end

  def mark_as_abandoned
    update(abandoned_at: Time.current) unless abandoned?
  end

  def remove_if_abandoned
    destroy if abandoned?
  end

  private

  def update_last_interaction_at
    self.update(last_interaction_at: Time.current)
  end
end
