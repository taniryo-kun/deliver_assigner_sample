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

# todo
# 既にアサインされている商品の移動先に近い商品が後からきたらそれもついでに一緒に配送して欲しい
# 配達中であれば現在地を頼りにすればいいが、配達予定だとアサイン商品の情報を見ないといけない（結果一律アサイン商品を見た方が良さそう）
# 一括で注文がきた時の割り振りロジック
# pickup場所、配達場所の近いものをグルーピングする必要がある？
# pickup場所が同じ(近く)であればなるべく同じ人に固めてアサインしたい
# 近い配達場所のものをなるべく同じ人に固めてアサインしたい
# 

# インプットデータ

# 該当時間に稼働中の配送員

class DeliverTest < Minitest::Test
  def setup
    @all_delivers = Deliver.all
    @del2, @del3, @del1, @del4 = @all_delivers
    @prod_gotanda, @prod_meguro, @prod_fudomae = FoodDeliveryProduct.all
  end

  def test_available_delivers
    available_delivers = Deliver.available_delivers(@all_delivers, @prod_gotanda.scheduled_picked_up_at)
    assert_equal [@del2, @del1, @del4], available_delivers
  end
end

class DeliveryAssignerTest < Minitest::Test
  def setup
    @assigner = DeliveryAssigner.new
    @all_delivers = Deliver.all
    @del_207, @del_nakanobu, @del_gotanda, @del_rinshi = @all_delivers
    @prod_gotanda, @prod_meguro, @prod_fudomae = FoodDeliveryProduct.all
    @available_delivers = Deliver.available_delivers(@all_delivers, @prod_gotanda.scheduled_picked_up_at)
  end

  def test_sort_by_distance
    sorted = @assigner.sort_by_distance(@available_delivers, @prod_gotanda.pickup_location)
    assert_equal @del_rinshi, sorted.first
  end

  def test_sort_by_status
    @assigner.assign(@del_gotanda, @prod_gotanda)
    @assigner.assign(@del_207, @prod_meguro)
    sorted = @assigner.sort_by_status(@available_delivers)
    assert_equal @del_rinshi, sorted.first
  end

  def test_sort_by_delivery_time
    sorted = @assigner.sort_by_delivery_time(@all_delivers, @prod_meguro)
    # puts @all_delivers.map { |d| d.name }
    # puts sorted.map { |d| d.name }
    assert_equal @del_rinshi, sorted.first
  end

  def test_all_deliver_full
    @assigner.assign(@del_gotanda, @prod_gotanda)
    @assigner.assign(@del_207, @prod_meguro)
    @assigner.assign(@del_rinshi, @prod_fudomae)
    candidates = @assigner.candidates(@available_delivers, @prod_fudomae)
    assert_equal [], candidates
  end

  def test_assign
    @assigner.assign(@del_gotanda, @prod_gotanda)
    assert @del_gotanda.products.include?(@prod_gotanda)
  end
end
