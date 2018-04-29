class AddBtcWalletAddressToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :btc_wallet_address, :string
  end
end
