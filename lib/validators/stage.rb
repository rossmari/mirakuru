class Validators::Stage

  attr_accessor :is_new_stage, :params, :errors

  def initialize(params)
    @params = params
    @is_new_stage = to_boolean(params[:is_new_stage])
    @errors = {}
  end

  def validate
    objects = validation_objects
    objects.each do |object|
      self.send("validate_#{object}")
    end
  end

  private

  def validate_stage_id
    unless params[:stage_id].present?
      @errors[:stage_id] = 'Не может быть пустым'
    end
  end

  def validate_stage
    stage = Stage.new(params[:stage])
    unless stage.valid?
      @errors[:stage] = stage.errors.to_h
    end
  end

  def validation_objects
    if is_new_stage
      [:stage]
    else
      [:stage_id]
    end
  end

  def to_boolean(value)
    value.to_i == 1
  end

end