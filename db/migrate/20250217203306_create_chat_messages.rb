class CreateChatMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_messages do |t|
      t.references :game, null: false, foreign_key: true
      t.string :author
      t.text :message

      t.timestamps
    end
  end
end
