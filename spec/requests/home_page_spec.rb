require 'spec_helper'

describe "my first test" do
  subject { page }

  describe "Home page" do
    before { visit '/' }
    it { should have_content('Noir') }
    it { should have_content('Black and White Film') }
  end

end
