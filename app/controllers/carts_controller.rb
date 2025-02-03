class CartsController < ApplicationController
  before_action :verify_or_create_cart, :verify_quantity

  def create
    product_id = cart_params[:product_id].to_i
    quantity = cart_params[:quantity].to_i

    product = Product.find_by(id: product_id)

    if product.nil?
      return render json: { error: "Produto não encontrado" }, status: :not_found
    end

    @cart.cart_products.create(product_id: product_id, quantity: quantity)
    @cart.touch

    render json: format_cart_response(@cart)
  end

  def show
    render json: format_cart_response(@cart)
  end

  def add_product
    product_id = cart_params[:product_id].to_i
    quantity = cart_params[:quantity].to_i

    product = Product.find_by(id: product_id)

    if product.nil?
      return render json: { error: "Produto não encontrado" }, status: :not_found
    end

    cart_product = @cart.cart_products.find_by(product_id: product_id)

    if cart_product
      cart_product.update(quantity: cart_product.quantity + quantity)
    else
      @cart.cart_products.create(product_id: product_id, quantity: quantity)
    end
    @cart.touch

    render json: format_cart_response(@cart)
  end

  def destroy
    product_id = params[:product_id].to_i
    cart_product = @cart.cart_products.find_by(product_id: product_id)

    if cart_product
      cart_product.destroy
      @cart.touch
      @cart.reload
      render json: format_cart_response(@cart)
    else
      render json: { error: "Produto não encontrado no carrinho" }, status: :not_found
    end
  end

  private

  def cart_params
    params.require(:cart).permit(:product_id, :quantity)
  end

  def verify_or_create_cart
    @cart = Cart.includes(cart_products: :product).find_by(id: session[:cart_id])

    if @cart.nil?
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end

  def verify_quantity
    if cart_params[:quantity].to_i.negative? || cart_params[:quantity].to_i.zero?
      return render json: { error: "Quantidade não pode ser menor que um" }, status: :not_acceptable
    end
  end

  def format_cart_response(cart)
    {
      id: cart.id,
      products: cart.cart_products.map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price,
          total_price: item.total_price
        }
      end,
      total_price: cart.total_price
    }
  end
end
