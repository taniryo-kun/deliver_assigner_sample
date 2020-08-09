class Deliver
 def initialize(name, locations, working_shifts, products = [])
   @name = name
   @deliver_locations = locations
   @working_shifts = working_shifts
   @products = products
 end

 def self.available_delivers(delivers, datetime)
  delivers.select do |d|
   d.available?(datetime)
  end
 end

 def current_location
  @deliver_locations.first
 end

 def available?(datetime)
  @working_shifts.find { |s| s.start_at <= datetime && s.end_at >= datetime }
 end
end