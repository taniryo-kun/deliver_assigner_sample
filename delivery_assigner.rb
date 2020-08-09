class DeliveryAssigner
  def candidates(delivers, product)
    sort_by_distance(delivers, product.pickup_location)
  end

  private

  def sort_by_distance(delivers, location)
    delivers.sort do |d1, d2|
      distance(d1.current_location, location) <=> distance(d2.current_location, location)
    end
  end

  def distance(location1, location2)
    height = location1.longitude - location2.longitude
    width = location1.latitude - location2.latitude
    Math.sqrt(height**2 + width**2)
  end
end