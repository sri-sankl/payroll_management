class CreateSalaryTaxes < ActiveRecord::Migration
  def change
    create_table :salary_taxes do |t|
      t.integer :employee_master_id
      t.date :financial_year_from
      t.date :financial_year_to
      t.integer :rent_per_month
      t.string :rent_receipt
      t.integer :standard_deduction
      t.integer :home_loan_amount
      t.string :home_loan_document
      t.integer :rent_received_per_month
      t.integer :other_tax
      t.integer :tax_paid
      t.integer :atg

      t.timestamps
    end
  end
end
