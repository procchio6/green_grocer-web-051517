def consolidate_cart(cart)
  cart.each_with_object({}) do |item, consolidated_cart|
    consolidated_cart[item.keys.first] ||= item.values.first
    consolidated_cart[item.keys.first][:count] ||= 0
    consolidated_cart[item.keys.first][:count] += 1
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      cart_item = cart[coupon[:item]]
      if cart_item[:count] >= coupon[:num]
        cart_item[:count] -= coupon[:num]
        cart["#{coupon[:item]} W/COUPON"] ||= {
          :price => coupon[:cost],
          :clearance => cart_item[:clearance],
          :count => 0
        }
        cart["#{coupon[:item]} W/COUPON"][:count] += 1
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, item_properties|
    if item_properties[:clearance]
      item_properties[:price] = (item_properties[:price] * 0.8).round(2)
    end
  end
  cart
end
require 'byebug'
def checkout(cart, coupons)
  cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = 0
  cart.each {|item, properties| total += properties[:price] * properties[:count]}
  if total > 100
    total *= 0.90
  end
  total
end
