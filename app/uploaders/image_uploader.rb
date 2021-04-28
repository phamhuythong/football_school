class ImageUploader < Shrine
  # plugins and uploading logic
  MAX_SIZE = 2 * 1024 * 1024 # 10MB
  plugin :validation_helpers

  Attacher.validate do
    validate_mime_type %w[image/gif image/jpeg image/png image/webp]
    # message = I18n.t('file tối đa 2Mb', max: MAX_SIZE / (1024 * 1024))
    message = 'file tối đa 2Mb'
    validate_max_size MAX_SIZE, message: message
  end
end