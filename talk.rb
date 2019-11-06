class Talk
  attr_accessor :title, :time_limit, :tracked, :order

  def initialize(title, time_limit)
    @title = title
    @time_limit = time_limit
    @tracked = false
    @order = -1
  end

  def self.all
    ObjectSpace.each_object(self).to_a
  end

  def self.count
    all.count
  end

  def tracked?
    self.tracked
  end

end
