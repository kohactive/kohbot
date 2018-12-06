class AddOpenAndDateAskedToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :open, :boolean
    add_column :questions, :date_asked, :date
  end
end
