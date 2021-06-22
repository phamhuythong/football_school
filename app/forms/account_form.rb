# frozen_string_literal: true

class AccountForm < BaseForm
  include ImageUploader[:avatar]
  attribute :email
  attribute :username
  attribute :password
  attribute :password_confirmation
  attribute :lock_version
  attribute :avatar_data

  # attribute :code
  # attribute :first_name
  # attribute :last_name
  # attribute :middle_name
  # attribute :gender
  # attribute :date_of_birth
  # attribute :phone
  # attribute :address
  # attribute :lock_version
  # attribute :avatar_data

  attr_accessor :first_name, :last_name, :middle_name, :gender, :date_of_birth, :phone, :address, :type, :args, :roles, :all_roles

  validates :email, presence: true
  validates :username, presence: true
  validates :password, presence: true, length: { minimum: 8 }, unless: :exist?
  validates_confirmation_of :password, unless: :exist?
  validates :first_name, presence: true
  validates :roles, presence: true
  validates :type, presence: true
  validate :email_unique
  validate :username_unique
  validate :uploaded_avatar

  def self.build(params = {})
    instance = new

    if params[:id]
      instance.record = Account.find(params[:id])
      return nil if instance.record.blank?

      instance.restore_from_record
    end

    instance.attributes = permitted_params(params) if params[:account_form].present?
    instance.assign_params(params)
    instance.load_association

    instance
  end

  def self.permitted_params(params)
    params.require(:account_form).permit :id, :email, :username, :password, :password_confirmation, :avatar, :lock_version,
                                         :first_name, :last_name, :middle_name, :gender, :date_of_birth, :phone, :address,
                                         :type, roles: []
  end

  def user_attrs
    %i[first_name last_name middle_name gender date_of_birth phone address type]
  end

  def assign_params(params)
    self.args = params[:account_form]
  end

  def load_association
    load_collection
    assign_association
  end

  def load_collection
    self.all_roles = Role.order(:name)
  end

  def assign_association
    assign_roles
    assign_user
  end

  def assign_roles
    if args&.dig(:roles).present?
      self.roles = args[:roles].reject { |c| c&.blank? }
    elsif record.present?
      self.roles = record.roles.map(&:name)
    end
  end

  def assign_user
    if args&.dig(:first_name).present?
      assign_user_params
    elsif record.present?
      assign_user_attributes
    end
  end

  def assign_user_params
    user_attrs.each do |param|
      send("#{param}=", args&.dig(param))
    end
  end

  def assign_user_attributes
    user = record.user
    user_attrs.each do |param|
      send("#{param}=", user&.send(param))
    end
  end

  def persist!
    ActiveRecord::Base.transaction do
      self.record = create! unless exist?
      update! if exist?
      self.roles = roles.reject { |r| r&.blank? }
      save_association
    end
  end

  def create!
    Account.create!(attributes_for_record)
  end

  def update!
    record.update!(attributes_for_record.tap { |hs| hs.delete('password') })
  end

  def save_association
    create_roles! unless exist?
    update_roles! if exist?
    save_user!
  end

  def create_roles!
    return if roles.blank?

    roles.each do |role|
      record.add_role role
    end
  end

  def update_roles!
    record.accounts_roles.delete_all
    create_roles!
  end

  def save_user!
    if record.user
      record.user.update!(attributes_for_nested_record(user_attrs))
    else
      user = record.build_user(attributes_for_nested_record(user_attrs))
      user.save!
    end
  end

  def uploaded_avatar
    avatar_attacher.errors.each do |error|
      errors.add(:avatar, error)
    end
  end

  def email_unique
    validate_uniqueness('Account', 'email')
  end

  def username_unique
    validate_uniqueness('Account', 'username')
  end
end
