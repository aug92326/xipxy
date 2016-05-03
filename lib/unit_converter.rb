class UnitConverter
  def initialize(value, from_unit)
    @value     = Float(value)
    @from_unit = from_unit
  end


  def to(to_unit)
    value = Unit("#{@value} #{@from_unit}") >> "#{to_unit}"
    Float(value.scalar).round(4)
  end


  class UnknownConversion < StandardError; end
end