require 'spec_helper'

describe User do
  before(:each) do
    @email = 'test@test.com'
    @pass = 'test123'
    @usr = User.new
    @usr.email = @email
    @usr.password = @pass
    @usr.password_confirmation = @pass
  end


  subject {@usr}
  it "should have id after saving" do
    @usr.save
    @usr.id.should_not be_nil
    @usr.delete
  end
  it "should not be able to duplicate email" do
    @usr.save
    @usr2 = User.new
    @usr2.email = @email
    @usr2.password = @password
    @usr2.password_confirmation = @password
    @usr2.should_not be_valid
    @usr.delete
  end
  it "should not allow empty password" do
    @usr.password = ''
    @usr.password_confirmation = ''
    @usr.should_not be_valid
  end

  it "should allow an update" do
    @usr.save
    @usr.email = 'new@email.com'
    @usr.save.should_not be_nil
    @usr.delete
  end
end

