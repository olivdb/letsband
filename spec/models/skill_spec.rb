require 'spec_helper'

describe Skill do
  let(:user) { FactoryGirl.create(:user) }
  let(:instrument) { FactoryGirl.create(:instrument) }
  let(:skill) { user.skills.build(instrument_id: instrument.id, expertise: 1, interest: 2) }

  subject { skill }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Skill.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "user and instrument methods" do    
    it { should respond_to(:user) }
    it { should respond_to(:instrument) }
    its(:user) { should == user }
    its(:instrument) { should == instrument }
  end

  describe "when user id is not present" do
    before { skill.user_id = nil }
    it { should_not be_valid }
  end

  describe "when instrument id is not present" do
    before { skill.instrument_id = nil }
    it { should_not be_valid }
  end
end
