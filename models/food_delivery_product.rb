class FoodDeliveryProduct
  attr_accessor :scheduled_picked_up_at, :scheduled_done_at, :pickup_location, :delivery_location

  def initialize(pickup_at, deliver_at, pickup_location, delivery_location)
    @scheduled_picked_up_at = pickup_at
    @scheduled_done_at = deliver_at
    @pickup_location = pickup_location
    @delivery_location = delivery_location
  end

  def self.all
    make_test_products
  end

  private
  # TODO: should move to test code
  def self.make_test_products
    gotanda = Location.new(35.622668, 139.720082)
    meguro = Location.new(35.634332, 139.712055)
    fudomae = Location.new(35.625796, 139.714111)
    osaki = Location.new(35.619523, 139.727000)
    musako = Location.new(35.620266, 139.703426)
    gonnosuke = Location.new(35.634517, 139.712854)
  
    [
      FoodDeliveryProduct.new(
        DateTime.parse('2020-08-09T10:00:00'),
        DateTime.parse('2020-08-09T10:30:00'),
        musako,
        gotanda
      ),
      FoodDeliveryProduct.new(
        DateTime.parse('2020-08-09T11:00:00'),
        DateTime.parse('2020-08-09T12:30:00'),
        gonnosuke,
        meguro
      ),
      FoodDeliveryProduct.new(
        DateTime.parse('2020-08-09T12:00:00'),
        DateTime.parse('2020-08-09T13:30:00'),
        osaki,
        fudomae
      )
    ]
  end
end