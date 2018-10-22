class CreateResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :responses do |t|
      t.string :answer
      t.string :user

      t.timestamps
    end
  end
end
