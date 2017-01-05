class OrderStageConstructor

  attr_accessor :is_new_stage, :params

  def initialize(params)
    @params = params
    @is_new_stage = to_boolean(params[:is_new_stage])
    @stage = nil
  end

  def process!
    process_stage
    save
  end

  private

  def save
    if is_new_stage
      @stage.save!
    end
  end

  def process_stage
    @stage =
      if is_new_stage
        Stage.new(params[:stage])
      else
        Stage.find(params[:stage_id])
      end
  end

  def to_boolean(value)
    value.to_i == 1
  end

end
