class DurationManager
  attr_reader :model

  def initialize(model)
    @model = model
  end

  def convertor(args={}, type="duration")
    times = {"hours" => 0, "minutes" => 0, "seconds" => 0}
    if args[type].present?
      args[type] = @model.new_record? ? times.merge(args[type]) : @model.send(:duration).merge(args[type])
    else
      args[type] = times if @model.new_record?
    end

    args[type]
  end

  def view_convertor
    @model.duration.map{|k,v| {k => v.to_i}}.reduce(:merge)
  end

end