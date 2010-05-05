# == Schema Information
# Schema version: 10
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)     default("")
#  password        :string(255)
#  stuff           :text            default("")
#  modes           :text            default("--- \n:priority_cap: 1000\n")
#  theme           :string(255)     default("default")
#  home_expression :text
#  remember_token  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
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
