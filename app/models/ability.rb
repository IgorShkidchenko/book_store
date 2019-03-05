class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    user_id = user.id

    if user.persisted?
      can :create, Review
      can %i[create update], Address
      can %i[read update], Order, user_id: user_id
      can %i[edit update destroy], User, id: user_id
    end

    can :read, Book
    can :read, Review
    can :update, Coupon
    can :create, Order
    can %i[index create update destroy], OrderItem, order: Order.user_checkout_orders(user_id).last
  end
end
