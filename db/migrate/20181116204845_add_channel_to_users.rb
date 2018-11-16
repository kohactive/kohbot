class AddChannelToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :channel, :string
  end
end
