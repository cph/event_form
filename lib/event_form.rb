require "event_form/version"

class EventForm
  attr_reader :attributes
  
  def self.assign(attributes)
    new(attributes)
  end
  
  def initialize(attributes)
    @attributes = attributes
  end
  
  def to(event)
    normalize_date_and_time_for_attribute!(attributes, :start)
    normalize_date_and_time_for_attribute!(attributes, :end)
    event.attributes = attributes
  end
  
private
  
  def normalize_date_and_time_for_attribute!(attributes, attribute)
    date = parse_date attributes.delete(:"#{attribute}_date")
    time = parse_time attributes.delete(:"#{attribute}_time")
    attributes[:"#{attribute}s_at"] = temp = from_date_and_time(date, time) if date
    attributes
  end
  
  def parse_date(date)
    return date unless date.is_a?(String)
    Date.parse(date)
  rescue ArgumentError
    nil
  end
  
  def parse_time(time)
    return time unless time.is_a?(String)
    Time.parse(time.strip.gsub(/(a|p)$/, '\1m'))
  rescue ArgumentError
    nil
  end
  
  def from_date_and_time(date, time)
    args = [date.year, date.month, date.day]
    args.concat [time.hour, time.min] if time
    Time.utc *args
  end  
end
