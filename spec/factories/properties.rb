# == Schema Information
#
# Table name: properties
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :property do
    name { Faker::Name.name }
  end
end
