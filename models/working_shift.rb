class WorkingShift
  attr_accessor :start_at, :end_at

  def initialize(start_at, end_at)
    @start_at = start_at
    @end_at = end_at
  end
end