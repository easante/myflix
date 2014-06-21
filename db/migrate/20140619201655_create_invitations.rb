class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :full_name
      t.string :email
      t.text :message
      t.string :token, index: true
      t.string :inviter_id, index: true

      t.timestamps
    end
  end
end
