class AddResponsesToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_reference :questions, :responses, foreign_key: true
  end
end
