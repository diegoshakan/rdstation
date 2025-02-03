require 'rails_helper'

RSpec.describe AbandonedCartsJob, type: :job do
  describe '#perform' do
    context 'when there are carts without interaction for more than 3 hours' do
      it 'marks carts as abandoned' do
        cart = create(:cart, last_interaction_at: 4.hours.ago)
        AbandonedCartsJob.perform_now

        expect(cart.reload.abandoned_at).not_to be_nil
      end
    end

    context 'when there are carts abandoned for more than 7 days' do
      it 'destroys carts' do
        cart = create(:cart, :abandoned, :cart_abandoned)
        AbandonedCartsJob.perform_now

        expect(Cart.exists?(cart.id)).to be_falsey
      end
    end

    context 'when there are no carts to update or destroy' do
      it 'does nothing' do
        cart = create(:cart, last_interaction_at: 1.hour.ago)
        AbandonedCartsJob.perform_now

        expect(cart.reload.abandoned_at).to be_nil
        expect(Cart.exists?(cart.id)).to be_truthy
      end
    end
  end
end
