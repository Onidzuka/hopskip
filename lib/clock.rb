require 'time'

class Clock
  TOTAL_DEGREES = 360
  MINUTES_PER_HOUR = 60
  MINUTE_AS_DEGREE = 6
  HOUR_AS_DEGREE = 0.5

  attr_accessor :hour, :minutes

  def initialize(clock)
    self.minutes = get_minutes(clock)
    self.hour = get_hour(clock)
  end

  def degree
    [get_first_part_degrees, TOTAL_DEGREES - get_first_part_degrees].min
  end

  private

  def get_first_part_degrees
    TOTAL_DEGREES - (hour_hand_as_degree + minute_hand_as_degree)
  end

  def get_hour(clock)
    hour = parse_clock(clock).strftime('%I').to_i
    hour == 12 ? 0 : hour
  end

  def get_minutes(clock)
    parse_clock(clock).strftime('%M').to_i
  end

  def hour_hand_as_degree
    (get_total_minutes * HOUR_AS_DEGREE).to_i
  end

  def minute_hand_as_degree
    minutes * MINUTE_AS_DEGREE
  end

  def get_total_minutes
    (hour * MINUTES_PER_HOUR) + minutes
  end

  def parse_clock(clock)
    DateTime.parse(clock)
  end
end