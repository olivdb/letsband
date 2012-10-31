require 'spec_helper'

describe Instrument do
  
  before do
    @instrument = Instrument.new(name: "Guitar")
  end

  subject { @instrument }

  it { should respond_to(:skills) }
  it { should respond_to(:users) }

  describe "add skill" do
    let(:user) { FactoryGirl.create(:user) }    
    before do
      @instrument.save
      user.skills.create!(instrument_id: @instrument.id, expertise: 1, interest: 2)
    end

    its(:users) { should include(user) }
  end
end
