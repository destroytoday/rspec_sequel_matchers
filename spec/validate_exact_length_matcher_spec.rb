require File.dirname(__FILE__) + "/spec_helper"

class Item < Sequel::Model
  def validate
    validates_exact_length 4, :name, :allow_nil => true
  end
end

describe "validate_exact_length_matcher" do

  subject{ Item }

  describe "arguments" do
    it "should require attribute" do
      lambda{
        @matcher = validate_exact_length
      }.should raise_error(ArgumentError)
    end
    it "should require additionnal parameters" do
      lambda{
        @matcher = validate_exact_length :name
      }.should raise_error(ArgumentError)
    end
    it "should refuse invalid additionnal parameters" do
      lambda{
        @matcher = validate_exact_length :id, :name
      }.should raise_error(ArgumentError)
    end
    it "should accept valid additionnal parameters" do
      lambda{
        @matcher = validate_exact_length 4, :name
      }.should_not raise_error(ArgumentError)
    end
  end

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = validate_exact_length 4, :name
        @matcher.description.should == "validate exact length of :name to 4"
      end
      it "should set failure messages" do
        @matcher = validate_exact_length 4, :name
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to validate exact length of :name to 4"
        @matcher.negative_failure_message.should == @matcher.failure_message.gsub("to validate", "to not validate")
      end
    end
    describe "with options" do
      it "should contain a description" do
        @matcher = validate_exact_length 4, :name, :allow_nil => true
        @matcher.description.should == "validate exact length of :name to 4 with :allow_nil => true"
      end
      it "should set failure messages" do
        @matcher = validate_exact_length 4, :price, :allow_nil => true
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to validate exact length of :price to 4 with :allow_nil => true"
        @matcher.negative_failure_message.should == @matcher.failure_message.gsub("to validate", "to not validate")
      end
      it "should explicit used options if different than expected" do
        @matcher = validate_exact_length 4, :name, :allow_blank => true
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to validate exact length of :name to 4 with :allow_blank => true but called with option(s) :allow_nil => true instead"
        @matcher.negative_failure_message.should == @matcher.failure_message.gsub("to validate", "to not validate")
      end
      it "should warn if invalid options are used" do
        @matcher = validate_exact_length 4, :name, :allow_anything => true
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to validate exact length of :name to 4 with :allow_anything => true but option :allow_anything is not valid"
        @matcher.negative_failure_message.should == @matcher.failure_message.gsub("to validate", "to not validate")
      end
    end
  end

  describe "matchers" do
    it{ should validate_exact_length(4, :name) }
    it{ should validate_exact_length(4, :name, :allow_nil => true) }
    it{ should_not validate_exact_length(4, :price) }
    it{ should_not validate_exact_length(3, :name) }
    it{ should_not validate_exact_length(4, :name, :allow_blank => true) }
  end

end