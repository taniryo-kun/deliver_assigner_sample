require 'minitest/autorun'
require 'date'
require 'pry'
require './delivery_assigner.rb'
Dir["./models/*.rb"].each {|file| require file }

# 注文から配送位置と配送開始時間を取得
# 配送開始時間に稼働中の配送員をリストアップ
# 配送員リストを点数化してソート
# 候補リストの上から順に打診

# テストケース
# 注文情報と配送員情報からアサイン候補リストが得られること
# アサイン候補リストの順番の妥当性

# インプットデータ

def make_test_product
  # 五反田TOC
  gotanda_toc = Location.new(35.622668, 139.720082)

  FoodDeliveryProduct.new(
    DateTime.parse('2020-08-09T10:00:00'),
    DateTime.parse('2020-08-09T10:30:00'),
    gotanda_toc
  )
end

def make_test_delivers
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
    []
  )
  deliver2 = Deliver.new(
    'deliver2',
    [nimarunana_office],
    [WorkingShift.new(
      DateTime.parse('2020-08-09T10:00:00'),
      DateTime.parse('2020-08-09T18:00:00')
    )],
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
    []
  )
  deliver4 = Deliver.new(
    'deliver4',
    [rinshi_park],
    [WorkingShift.new(
      DateTime.parse('2020-08-09T09:00:00'),
      DateTime.parse('2020-08-09T19:00:00')
    )],
    []
  )
  [deliver2, deliver3, deliver1, deliver4]
end

# 該当時間に稼働中の配送員

class DeliverTest < Minitest::Test
  def setup
    @all_delivers = make_test_delivers
    @del2, @del3, @del1, @del4 = @all_delivers
    @product = make_test_product
  end

  def test_available_delivers
    available_delivers = Deliver.available_delivers(@all_delivers, @product.scheduled_picked_up_at)
    assert_equal [@del2, @del1, @del4], available_delivers
  end
end

class DeliveryAssignerTest < Minitest::Test
  def setup
    @all_delivers = make_test_delivers
    @del_207, @del_nakanobu, @del_gotanda, @del_rinshi = @all_delivers
    @product = make_test_product
  end

  def test_candidates
    assigner = DeliveryAssigner.new
    available_delivers = Deliver.available_delivers(@all_delivers, @product.scheduled_picked_up_at)
    candidates = assigner.candidates(available_delivers, @product)
    assert_equal @del_gotanda, candidates.first
  end

  # def test_suggest
  # end

  # def test_assign
  # end
end
