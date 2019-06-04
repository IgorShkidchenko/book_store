require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'when user persisted' do
    let(:user) { create(:user) }

    it { is_expected.to be_able_to :create, Review }
    it { is_expected.to be_able_to %i[create update], Address }
    it { is_expected.to be_able_to %i[read update], Order, user_id: user.id }
    it { is_expected.to be_able_to %i[edit update destroy], User, id: user.id }
    it { is_expected.to be_able_to :read, Book }
    it { is_expected.to be_able_to :read, Review }
    it { is_expected.to be_able_to :read, Category }
    it { is_expected.to be_able_to :update, Coupon }
    it { is_expected.to be_able_to :create, Order }
    it { is_expected.to be_able_to %i[index create update destroy], OrderItem, order: Order.orders_in_checkout_state_of_user(user.id) }
  end

  describe 'when user is not logged in' do
    let(:user) { build(:user) }

    it { is_expected.not_to be_able_to :create, Review }
    it { is_expected.not_to be_able_to %i[create update], Address }
    it { is_expected.not_to be_able_to %i[read update], Order, user_id: user.id }
    it { is_expected.not_to be_able_to %i[edit update destroy], User, id: user.id }

    it { is_expected.to be_able_to :read, Book }
    it { is_expected.to be_able_to :read, Category }
    it { is_expected.to be_able_to :read, Review }
    it { is_expected.to be_able_to :update, Coupon }
    it { is_expected.to be_able_to :create, Order }
    it { is_expected.to be_able_to %i[index create update destroy], OrderItem, order: Order.orders_in_checkout_state_of_user(user.id) }
  end
end
