class City < ApplicationRecord
	validates :name, presence: :true, uniqueness: { scope: :state }
	validates :state, presence: :true
end
