# frozen_string_literal: true

require 'yaml'

namespace :db do
  desc 'initialize roles'
  task :initialize_roles => :environment do
    # script_file = File.join(Rails.root, 'db', 'change_teacher.rb')
    # load(script_file) if File.exist?(script_file)
    ActiveRecord::Base.transaction do
      puts "******Initialize roles************"
      Role::ROLES.each do |k, v|
        puts "Imported role #{v.capitalize}" if Role.find_or_create_by!(name: v)
      end
      puts "******COMPLETED******************"
    rescue => e
      puts '------------ERROR--------------------------------'
      puts e
      raise ActiveRecord::Rollback
    end
  end

  task :create_account, [:email, :username, :password, :role] => :environment do |t, args|
    email = args[:email]
    username = args[:username]
    password = args[:password]
    role = args[:role]
    account = Account.find_or_create_by(email: email, username: username, password: password)
    account.add_role role
  end
end