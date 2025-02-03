class AbandonedCartsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    verify_abandoned_carts
    destroy_abandoned_carts
  end

  private

  def verify_abandoned_carts
    CartJobs::VerifyCarts.update_abandoned_carts
  end

  def destroy_abandoned_carts
    CartJobs::VerifyCarts.destroy_abandoned_carts
  end
end
