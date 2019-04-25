class CreateAccountSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :account_settings do |t|
      t.integer :user_id
      t.boolean :message_email
      t.boolean :message_push_notification
      t.boolean :message_text_message
      t.boolean :reminder_email
      t.boolean :reminder_push_notification
      t.boolean :reminder_text_message
      t.boolean :promotion_and_tip_email
      t.boolean :promotion_and_tip_push_notification
      t.boolean :promotion_and_tip_text_message
      t.boolean :promotion_and_tip_phone_call
      t.boolean :policy_and_community_email
      t.boolean :policy_and_community_push_notification
      t.boolean :policy_and_community_text_message
      t.boolean :policy_and_community_phone_call
      t.boolean :account_support_email, default: true
      t.boolean :account_support_push_notification
      t.boolean :account_support_text_message

      t.timestamps
    end
  end
end
