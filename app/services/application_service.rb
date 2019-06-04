class ApplicationService
  def call
    raise NotImplementedError
  end

  def self.call(*args, &block)
    new(*args, &block).call
  end
end
