FactoryBot.define do
  factory :account do
    holder_first_name { 'John' }
    holder_last_name  { 'Doe' }
    holder_cpf        { generate_cpf }
    balance_in_cents  { 1_000 }
    password          { 'password123' }
    password_confirmation { 'password123' }
  end
end

def generate_cpf
  cpf = []
  11.times { cpf << rand(0..9) }

  cpf.join
end
