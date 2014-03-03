require 'spec_helper'

describe "User manipulation" do
  subject { page }

  describe "signup" do
    before { visit '/signup' }

    it {should have_content('Email')}

    it "registers me" do
      within("form") do
        fill_in 'user[email]', :with => 'user@example.com'
        fill_in 'user[password]', :with => 'test123'
        fill_in 'user[password_confirmation]', :with => 'test123'
      end
    end
  end
end


  
