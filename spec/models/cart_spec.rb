
require 'spec_helper'

describe Cart do
  before(:all) do
    @session_id = 'slkjweor'
    @user_id = 12
  end

  it "should create a new cart given only a session_id" do
    @cart = Cart.fetch(@session_id, nil)
    @cart.should_not be_nil
    Cart.find(:session_id => @session_id).should_not be_nil
  end

  it "should create a new user cart given a session and user id" do
    @cart = Cart.fetch(@session_id, @user_id)
    @cart.should_not be_nil
    Cart.find(:user_id => @user_id).should_not be_nil
    @cart.delete
  end

  it "should move items from session cart into user cart" do
    # Create a cart using a session
    @cart = Cart.fetch(@session_id,nil)
    it = @cart.add_item(:film_id => 1, :film_type_id => 1, :processing_id => 1)
    it.save
    @cart_id = @cart.id
    @cart.items.length.should equal(1)
    @cart.user_id.should_not equal(@user_id)

    # Refetch that cart with a user_id... this should trigger items to be moved to the new cart
    @cart2 = Cart.fetch(@session_id,@user_id)
    @cart2.items.length.should equal(1)
    @cart2.id.should_not equal(@cart_id)
    @cart = Cart.find(:id => @cart.id)
    @cart.should be_nil
  end
end
