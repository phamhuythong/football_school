require 'shrine'
require 'shrine/storage/file_system'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'), # temporary
  store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads'),       # permanent
}

Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :remove_attachment
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files


# require "shrine"
# require "shrine/storage/file_system"
# require "shrine/storage/s3"

# if (Rails.env.production? || Rails.env.staging?) && ENV['AWS_ACCESS_KEY_ID'].present? && ENV['AWS_SECRET_ACCESS_KEY'].present?
#   s3_options = {
#     bucket: ENV['S3_BUCKET_NAME'],
#     region: ENV['S3_REGION'],
#     access_key_id: ENV['AWS_ACCESS_KEY_ID'],
#     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
#   }

#   Shrine.storages = {
#     cache: Shrine::Storage::S3.new(prefix: 'uploads/cache', **s3_options),
#     store: Shrine::Storage::S3.new(prefix: 'uploads', **s3_options)
#   }
# else
#   Shrine.storages = {
#     cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
#     store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store')
#   }
# end

# Shrine.plugin :activerecord
# Shrine.plugin :cached_attachment_data
# Shrine.plugin :remove_attachment
# Shrine.plugin :validation_helpers
# Shrine.plugin :determine_mime_type
# Shrine.plugin :download_endpoint, prefix: "attachments", disposition: :attachment
# Shrine.plugin :remote_url, max_size: 20*1024*1024

# if Rails.env.production?
#   Shrine.plugin :url_options,
#     cache: { host: "https://#{ENV['HOST']}", public: true },
#     store: { host: "https://#{ENV['HOST']}", public: true }
# end
