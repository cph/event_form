require "test_helper"

class EventFormTest < ActiveSupport::TestCase
  attr_accessor :params
  
  
  context "Given a start_time and start_date" do
    setup do
      self.params = {
        "start_date" => "2014-04-15",
        "start_time" => "4:50 PM"
      }.with_indifferent_access
    end
    
    should "combine them to assign starts_at" do
      EventForm.assign(params).to(event)
      assert_equal Time.utc(2014, 4, 15, 16, 50), event.attributes[:starts_at]
    end
  end
  
  
  context "with local time" do
    setup do
      Time.zone = "Eastern Time (US & Canada)"
    end
    
    context "Given a start_time and start_date" do
      setup do
        self.params = {
          "start_date" => "2014-04-15",
          "start_time" => "4:50 PM"
        }.with_indifferent_access
      end
      
      should "combine them to assign starts_at" do
        EventForm.assign(params).with_local_time.to(event)
        assert_equal Time.zone.local(2014, 4, 15, 16, 50), event.attributes[:starts_at]
      end
    end
  end
  
  
  context "Given just a start_date" do
    setup do
      self.params = {
        "start_date" => "2014-04-15"
      }.with_indifferent_access
    end
    
    should "assign the date to starts_at" do
      EventForm.assign(params).to(event)
      assert_equal Date.new(2014, 4, 15), event.attributes[:starts_at]
    end
  end
  
  
  context "Given an invalid time" do
    setup do
      self.params = {
        "start_date" => "2014-04-15",
        "start_time" => "nope"
      }.with_indifferent_access
    end
    
    should "assign the date to starts_at" do
      EventForm.assign(params).to(event)
      assert_equal Date.new(2014, 4, 15), event.attributes[:starts_at]
    end
  end
  
  
  context "Given a blank time" do
    setup do
      self.params = {
        "start_date" => "2014-04-15",
        "start_time" => ""
      }.with_indifferent_access
    end
    
    should "assign the date to starts_at" do
      EventForm.assign(params).to(event)
      assert_equal Date.new(2014, 4, 15), event.attributes[:starts_at]
    end
  end
  
  
  context "Given an invalid date" do
    setup do
      self.params = {
        "start_date" => "nope"
      }.with_indifferent_access
    end
    
    should "assign nil to starts_at" do
      EventForm.assign(params).to(event)
      assert_equal nil, event.attributes[:starts_at]
    end
  end
  
  
private
  
  def event
    @event ||= Struct.new(:attributes).new({})
  end
  
end
