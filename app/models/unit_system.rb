class UnitSystem
  attr_reader :name, :label, :units

  DEFAULT = 'METRIC'

  #TODO: remove all code except ::units_for along with json.systemOfUnits
  def self.units_for(system =  DEFAULT)
    units = Settings.unit_kinds.each_with_object({}) do |(kind, unit), obj|
      convertable = unit[system]
      obj[kind] = convertable ? convertable['name'] : unit['name']
    end
    { name: system, label: system, units: units }
  end

  def self.all
    [ UnitSystem::METRIC, UnitSystem::STANDARD ]
  end

  def initialize(name, units)
    @name  = name
    @label = name
    @units = units
  end

  def unit_for(type)
    @units[type] or raise UnitSystem::UnknownUnitType
  end

  class UnknownUnitType < StandardError; end
end

UnitSystem::METRIC = UnitSystem.new(UnitSystem::DEFAULT, {
  weight:            :kilogram
})

UnitSystem::STANDARD = UnitSystem.new('STANDARD', {
  weight:            :pound
})
