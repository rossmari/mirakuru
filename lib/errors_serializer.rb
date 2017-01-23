class ErrorsSerializer

  attr_reader :errors, :result

  def initialize(errors)
    @errors = errors
    @result = {}
  end

  def serialize
    prepare_hash('', errors)
    result
  end

  private

  def prepare_hash(initial_path, hash)
    initial_path ||= ''
    next_level_path = ''
    val = nil
    hash.each do |key, value|
      next_level_path =
        if initial_path.empty?
          initial_path + key.to_s
        else
          initial_path + "[#{key}]"
        end
      if value.is_a?(Hash)
        next_level_path, val = prepare_hash(next_level_path, value)
      else
        @result[next_level_path] = value
      end
    end
   return next_level_path, val
  end

end