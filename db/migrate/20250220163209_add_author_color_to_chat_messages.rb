class AddAuthorColorToChatMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :chat_messages, :author_color, :string
  end
end
