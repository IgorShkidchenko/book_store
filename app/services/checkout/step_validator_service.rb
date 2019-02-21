class Checkout::StepValidatorService < Checkout::BaseService
  attr_reader :new_step

  def initialize(order:, step:, authenticate:)
    super(order: order, step: step)
    @authenticate = authenticate
  end

  def call
    return @new_step = :quick_authenticate unless @authenticate
    return @new_step = :complete if @step == :complete && @order.editing?

    @order.editing? ? user_edit_step : standart_steps_flow
  end

  def step_invalid?
    @new_step != @step
  end

  private

  def standart_steps_flow
    case
    when @order.new? then @new_step = :address
    when @order.fill_delivery? then @new_step = :delivery
    when @order.fill_payment? then @new_step = :payment
    else :confirm
    end
  end

  def user_edit_step
    return @new_step = :confirm if %i[complete quick_authenticate].include? @step

    @new_step = @step
  end
end
