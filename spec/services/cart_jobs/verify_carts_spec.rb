require 'rails_helper'

RSpec.describe CartJobs::VerifyCarts, type: :service do
  describe '.update_abandoned_carts' do
    context 'when there are carts without interaction for more than 3 hours' do
      let!(:abandoned_cart) { create(:cart, last_interaction_at: 4.hours.ago) }
      let!(:active_cart) { create(:cart, last_interaction_at: 1.hour.ago) }

      it 'abandoned carts as abandoned' do
        expect { described_class.update_abandoned_carts }
          .to change { abandoned_cart.reload.abandoned_at }.from(nil).to(be_present)
      end
    end
  end

  describe '.destroy_abandoned_carts' do
    context 'when there are carts abandoned for more than 7 days' do
      let!(:old_abandoned_cart) { create(:cart, :abandoned, :cart_abandoned) }
      let!(:recently_abandoned_cart) { create(:cart, :abandoned, abandoned_at: 6.days.ago) }

      it 'destroys old abandoned carts' do
        expect { described_class.destroy_abandoned_carts }
          .to change { Cart.count }.by(-1)
        expect(Cart.exists?(old_abandoned_cart.id)).to be_falsey
      end
    end
  end
end