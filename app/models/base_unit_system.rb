class BaseUnitSystem < ActiveRecord::Base
  AVAILABLE_SYSTEMS = %w( METRIC STANDARD )
  DEFAULT = 'STANDARD'
  validates :label, uniqueness: true, presence: true, inclusion: AVAILABLE_SYSTEMS


  def self.nil_size
    {height: {standard: 0, metric: 0}, width: {standard: 0, metric: 0}, depth: {standard: 0, metric: 0}}
  end

  def self.nil_weight
    {standard: 0, metric: 0}
  end

  def self.fake_size
    h = Faker::Number.decimal(2).to_f
    w = Faker::Number.decimal(2).to_f
    d = Faker::Number.decimal(2).to_f

    {height: {standard: UnitConverter.new(h, 'cm').to('in'), metric: h}, width: {standard: UnitConverter.new(w, 'cm').to('in'), metric: w}, depth: {standard: UnitConverter.new(d, 'cm').to('in'), metric: d}}
  end

  def self.fake_weight
    w = ("0.11").to_f
    {standard: UnitConverter.new(w, 'kg').to('lb'), metric: w}
  end

  def self.default_system
    self.find_by_label(self::DEFAULT)
  end

  def self.weight_convertor(model, args={})
    #{"metric"=>"0.11", "standard"=>"0.24251"}
    system = args['system'].present? ? args['system'] : model.system
    is_metric_system = system != BaseUnitSystem::DEFAULT.downcase
    value = args['weight']
    metric_value = is_metric_system ? value : UnitConverter.new(value, 'lb').to('kg')
    standard_value = is_metric_system ? UnitConverter.new(value, 'kg').to('lb') : value

    { standard: standard_value, metric: metric_value }
  end

  def self.size_convertor(model, args={}, type="size")
    if args[type].present?
      #{"depth"=>"{:standard=>24.56299, :metric=>62.39}", "width"=>"{:standard=>23.52756, :metric=>59.76}", "height"=>"{:standard=>17.64567, :metric=>44.82}"}
      #{"depth"=>"232", "width"=>"232", "height"=>"232"}
      current_sizes = model.send(type)
      new_sizes = {}
      system = args['system'].present? ? args['system'] : model.system
      is_metric_system = system != BaseUnitSystem::DEFAULT.downcase

      args[type].each do |attr|
        metric_value = is_metric_system ? attr[1] : UnitConverter.new(attr[1], 'in').to('cm')
        standard_value = is_metric_system ? UnitConverter.new(attr[1], 'cm').to('in') : attr[1]
        new_sizes[attr[0]] = {standard: standard_value, metric: metric_value}
      end
      args[type] = current_sizes.merge(new_sizes)
    end

    args[type]
  end

  def self.size_to_json size
    size.each do |v|
      size[v[0]] = eval(v[1])
    end
  end

  def self.weight_to_json weight
    weight.inject({}) { |h, (k, v)| h[k] = v.to_f; h }
  end

end
