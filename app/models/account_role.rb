# frozen_string_literal: true

# table_name = accounts_roles
# t.bigint "account_id"
# t.bigint "role_id"
# t.index ["account_id", "role_id"], name: "index_accounts_roles_on_account_id_and_role_id"
# t.index ["account_id"], name: "index_accounts_roles_on_account_id"
# t.index ["role_id"], name: "index_accounts_roles_on_role_id"

class AccountRole < ApplicationRecord
  self.table_name = :accounts_roles
  belongs_to :role, inverse_of: :account_roles
  belongs_to :account, inverse_of: :account_roles
end
