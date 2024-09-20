class RenameAnswers < ActiveRecord::Migration[7.0]
  def change
    rename_table :answers, :responses
  end
end
