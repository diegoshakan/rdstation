class AbandonedCartsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    update_abandoned_carts
    destroy_abandoned_carts
  end

  private

  def update_abandoned_carts
    carts_without_interaction = Cart.where(abandoned_at: nil).where('last_interaction_at < ?', 5.seconds.ago)

    carts_without_interaction.each do |cart|
      cart.mark_as_abandoned
    end
  end

  def destroy_abandoned_carts
    old_carts = Cart.where.not(abandoned_at: nil).where('abandoned_at < ?', 10.seconds.ago)
    old_carts.destroy_all
  end
end
