# frozen_string_literal: true

class AddConfirmableToDevise < ActiveRecord::Migration[5.2]
  # NOTE: You can't use change, as User.update_all will fail in the down migration
  def up
    # add_column :users, :confirmation_token, :string
    # add_column :users, :confirmed_at, :datetime
    # add_column :users, :confirmation_sent_at, :datetime
    # add_column :users, :unconfirmed_email, :string # Only if using reconfirmable
    # add_index :users, :confirmation_token, unique: true

    change_table :users, bulk: true do |t|
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email # Only if using reconfirmable
      t.index :confirmation_token, unique: true
    end
    # User.reset_column_information # Need for some types of updates, but not for update_all.
    # To avoid a short time window between running the migration and updating all existing
    # users as confirmed, do the following
    # User.update_all confirmed_at: DateTime.now
    User.find_each { |u| u.update(confirmed_at: DateTime.now) }
    # All existing user accounts should be able to log in after this.
  end

  def down
    remove_index :users, :confirmation_token
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at
    remove_columns :users, :unconfirmed_email # Only if using reconfirmable

    # change_table :users, bulk: true do |t|
    #   t.remove :confirmation_token
    #   t.remove :confirmed_at
    #   t.remove :confirmation_sent_at
    #   t.remove :unconfirmed_email # Only if using reconfirmable
    #   t.remove :confirmation_token, unique: true
    # end
  end
end
