FactoryBot.define do
  factory :transaction do
    debit_account { FactoryBot.create(:account) }
    credit_account { FactoryBot.create(:account) }
    processed_at { Time.zone.now }
    amount_in_cents { 100 }
  end
end
