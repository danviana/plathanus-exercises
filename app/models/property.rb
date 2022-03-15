# == Schema Information
#
# Table name: properties
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Property < ApplicationRecord
  validates :name, presence: true, allow_blank: false

  has_many_attached :images
end
