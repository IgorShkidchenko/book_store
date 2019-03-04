class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.persisted?
      can :create, Review
      can %i[create update], Address
      can %i[read update], Order, user_id: user.id
      can %i[edit update destroy], User, id: user.id
    end

    can :read, Book
    can :read, Review
    can :update, Coupon
    can :create, Order
    can %i[index create update destroy], OrderItem, order: Order.user_checkout_orders(user.id).last
  end
end
