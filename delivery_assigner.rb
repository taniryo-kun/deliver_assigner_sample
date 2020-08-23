class DeliveryAssigner
  def candidates(delivers, product)
    sorted = sort_by_status(delivers)
    return [] unless sorted.first.products.empty?

    sort_by_delivery_time(sorted, product)
  end

  def assign(deliver, product)
    deliver.assign_product(product)
  end

  def sort_by_distance(delivers, location)
    delivers.sort do |d1, d2|
      distance(d1.current_location, location) <=> distance(d2.current_location, location)
    end
  end

  def sort_by_status(delivers)
    non_assigned = delivers.select { |d| d.products.empty? }
    assigned = delivers.reject { |d| d.products.empty? }
    non_assigned.concat assigned
  end

  def sort_by_delivery_time(delivers, product)
    delivers.sort do |d1, d2|
      delivery_time(d1, product) <=> delivery_time(d2, product)
    end
  end

  private

  def distance(location1, location2)
    # 緯度経度をラジアンに変換
    rlat1 = location1.latitude * Math::PI / 180
    rlng1 = location1.longitude * Math::PI / 180
    rlat2 = location2.latitude * Math::PI / 180
    rlng2 = location2.longitude * Math::PI / 180
  
    # 2点の中心角(ラジアン)を求める
    a =
      Math::sin(rlat1) * Math::sin(rlat2) +
      Math::cos(rlat1) * Math::cos(rlat2) *
      Math::cos(rlng1 - rlng2)
    rr = Math::acos(a)
  
    earth_radius = 6378.140 # 地球赤道半径(キロメートル)
    earth_radius * rr
  end

  def delivery_time(deliver, product)
    pickup_dist = distance(deliver.current_location, product.pickup_location)
    delivery_dist = distance(product.pickup_location, product.delivery_location)
    # puts deliver.name
    # puts 'distance:'
    # puts pickup_dist
    # puts 'to pickup:'
    # puts pickup_dist / deliver.kilo_per_hour
    # puts 'delivery_dist:'
    # puts delivery_dist
    # puts 'to delivery:'
    # puts delivery_dist / deliver.kilo_per_hour
    # puts 'total time:'
    # puts pickup_dist + delivery_dist
    # puts ((pickup_dist / deliver.kilo_per_hour) + (delivery_dist / deliver.kilo_per_hour)) * 60

    (pickup_dist / deliver.kilo_per_hour) + (delivery_dist / deliver.kilo_per_hour)
  end
end