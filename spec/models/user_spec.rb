# == Schema Information
# Schema version: 7
#
# Table name: users
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  email          :string(255)     default("")
#  password       :string(255)
#  modes          :string(255)     default("--- {}\n\n")
#  created_at     :datetime
#  updated_at     :datetime
#  remember_token :string(255)
#

require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :email => "value for email"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
end
