class BaseService
  attr_reader :error_message

  def initialize(*args)
    @args = args
    @error_message = ''
    @success = true

    set_attributes
  end

  def self.call(*args)
    new(*args).call
  end

  def call
    raise NotImplementedError
  end

  def success?
    @success
  end

  def fail!(message)
    @success = false
    @error_message = message

    self
  end

  private

  def set_attributes
    @args.each do |arg| 
      arg.keys.each do |key|
        class_eval { attr_accessor key }
        instance_variable_set("@#{key}", arg[key])
      end
    end
  end
end