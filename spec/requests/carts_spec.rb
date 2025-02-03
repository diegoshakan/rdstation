require 'rails_helper'

RSpec.describe "/carts", type: :request do
  before do
    allow_any_instance_of(CartsController).to receive(:session).and_return(cart_id: cart.id)
  end

  describe 'POST /cart' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let!(:cart_product) { create(:cart_product, cart: cart, product: product, quantity: 1) }
    
    context 'with valid parameters' do
      it 'creates a new cart and adds a product' do
        post '/cart', params: { cart: { product_id: product.id, quantity: 2 } }

        expect(response).to have_http_status(:ok)
        expect(json_response[:id]).to be_present
        expect(json_response[:products].size).to eq(2)
        expect(json_response[:products].first[:id]).to eq(product.id)
      end
    end

    context 'with invalid product_id' do
      it 'returns a not found error' do
        post '/cart', params: { cart: { product_id: 999, quantity: 2 } }

        expect(response).to have_http_status(:not_found)
        expect(json_response[:error]).to eq('Produto não encontrado')
      end
    end

    context 'with invalid quantity' do
      it 'returns an error for zero quantity' do
        post '/cart', params: { cart: { product_id: product.id, quantity: 0 } }

        expect(response).to have_http_status(:not_acceptable)
        expect(json_response[:error]).to eq('Quantidade não pode ser menor que um')
      end

      it 'returns an error for negative quantity' do
        post '/cart', params: { cart: { product_id: product.id, quantity: -1 } }

        expect(response).to have_http_status(:not_acceptable)
        expect(json_response[:error]).to eq('Quantidade não pode ser menor que um')
      end
    end
  end

  describe 'GET /cart' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let!(:cart_product) { create(:cart_product, cart: cart, product: product, quantity: 1) }

    
    xit 'returns the current cart' do
      allow_any_instance_of(CartsController).to receive(:session).and_return(cart_id: cart.id)
      get '/cart'

      expect(response).to have_http_status(:ok)
      expect(json_response[:id]).to eq(cart.id)
      expect(json_response[:products]).to be_empty
    end
  end

  describe "POST /add_product" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let!(:cart_product) { create(:cart_product, cart: cart, product: product, quantity: 1) }

    before do
      allow_any_instance_of(CartsController).to receive(:session).and_return(cart_id: cart.id)
    end

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_item', params: { cart: { product_id: product.id, quantity: 1 } }, as: :json
        post '/cart/add_item', params: { cart: { product_id: product.id, quantity: 1 } }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do

        expect { subject }.to change { cart_product.reload.quantity }.by(2)
      end
    end
  end

  describe 'DELETE /cart/:product_id' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }

    context 'when the product is in the cart' do
      xit 'removes the product from the cart' do
        cart_product = create(:cart_product, cart: cart, product: product)
        delete "/cart/#{product.id}"

        
        expect(response).to have_http_status(:ok)
        expect(json_response[:products]).to be_empty
      end
    end

    context 'when the product is not in the cart' do
      xit 'returns a not found error' do
        delete "/cart/999"

        expect(response).to have_http_status(:not_found)
        expect(json_response[:error]).to eq('Produto não encontrado no carrinho')
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end
