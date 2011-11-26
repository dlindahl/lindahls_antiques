class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :paymentable, :polymorphic => true
      t.decimal :amount, :precision => 7, :scale => 2, :default => 0.0
      t.string  :type, :reference_number, :description

      t.timestamps
    end
  end
end
