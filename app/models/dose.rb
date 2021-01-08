class Dose < ApplicationRecord
  belongs_to :cocktail
  belongs_to :ingredient
  delegate :name, :to => :ingredient, :prefix => true

  validates :cocktail, presence: true
  validates :description, presence: true
  validates :ingredient, uniqueness: { scope: :cocktail }
  # validates :cocktail, :ingredient, uniqueness: true
end
