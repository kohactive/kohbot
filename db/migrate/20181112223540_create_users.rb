class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :ucode
      t.boolean :active

      t.timestamps
    end
  end
end
