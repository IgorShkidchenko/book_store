FactoryBot.define do
  factory :order_status do
    name { OrderStatus::STATUSES[:in_progress] }
    id { 1 }
  end
end
