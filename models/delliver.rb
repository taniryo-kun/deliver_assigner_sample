WALKING = 4
BICYCLE = 15
CAR = 30
BIKE = 40

class Deliver
  attr_accessor :name, :products, :kilo_per_hour

  def initialize(name, locations, working_shifts, kilo_per_hour, products = [])
    @name = name
    @deliver_locations = locations
    @working_shifts = working_shifts
    @kilo_per_hour = kilo_per_hour
    @products = products
  end

  def self.available_delivers(delivers, datetime)
    delivers.select do |d|
      d.available?(datetime)
    end
  end

  def self.all
    make_test_delivers
  end

  def current_location
    @deliver_locations.first
  end

  def available?(datetime)
    @working_shifts.find { |s| s.start_at <= datetime && s.end_at >= datetime }
  end

  def assign_product(product)
    @products << product
  end

  private
  # TODO: should move to test code
  def self.make_test_delivers
    # 五反田駅
    gotanda_sta = Location.new(35.625889, 139.723549)
    # 207オフィス
    nimarunana_office = Location.new(35.633098, 139.703881)
    # 荏原中延駅
    ebaranokanobu_sta = Location.new(35.610176, 139.711907)
    # 林試の森公園
    rinshi_park = Location.new(35.625594, 139.702976)

    deliver1 = Deliver.new(
      'deliver1',
      [gotanda_sta],
      [WorkingShift.new(
        DateTime.parse('2020-08-09T10:00:00'),
        DateTime.parse('2020-08-09T15:00:00')
      )],
      WALKING,
      []
    )
    deliver2 = Deliver.new(
      'deliver2',
      [nimarunana_office],
      [WorkingShift.new(
        DateTime.parse('2020-08-09T10:00:00'),
        DateTime.parse('2020-08-09T18:00:00')
      )],
      BICYCLE,
      []
    )
    deliver3 = Deliver.new(
      'deliver3',
      [ebaranokanobu_sta],
      [WorkingShift.new(
        DateTime.parse('2020-08-09T13:00:00'),
        DateTime.parse('2020-08-09T19:00:00')
      ), WorkingShift.new(
        DateTime.parse('2020-08-10T10:00:00'),
        DateTime.parse('2020-08-10T12:00:00')
      )],
      CAR,
      []
    )
    deliver4 = Deliver.new(
      'deliver4',
      [rinshi_park],
      [WorkingShift.new(
        DateTime.parse('2020-08-09T09:00:00'),
        DateTime.parse('2020-08-09T19:00:00')
      )],
      BIKE,
      []
    )
    [deliver2, deliver3, deliver1, deliver4]
  end
end