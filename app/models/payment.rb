class Payment < ActiveRecord::Base
  belongs_to :paymentable, :polymorphic => true

  validates_numericality_of :amount, :greater_than_or_equal_to => 0.0
end