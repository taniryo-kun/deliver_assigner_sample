class FoodDeliveryProduct
  attr_accessor :scheduled_picked_up_at, :scheduled_done_at, :pickup_location

  def initialize(pickup_at, deliver_at, location)
    @scheduled_picked_up_at = pickup_at
    @scheduled_done_at = deliver_at
    @pickup_location = location
  end
end