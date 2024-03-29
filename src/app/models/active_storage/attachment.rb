require "active_support/core_ext/module/delegation"
class ActiveStorage::Attachment < ActiveStorage::Record
  self.table_name = "active_storage_attachments"
  belongs_to :record, polymorphic: true, touch: true
  belongs_to :blob, class_name: "ActiveStorage::Blob", autosave: true
  delegate_missing_to :blob
  delegate :signed_id, to: :blob
  after_create_commit :mirror_blob_later, :analyze_blob_later
  after_destroy_commit :purge_dependent_blob_later
  scope :with_all_variant_records, -> { includes(blob: :variant_records) }
  def purge
    transaction do
      delete
      record.touch if record&.persisted?
    end
    blob&.purge
  end
  def purge_later
    transaction do
      delete
      record.touch if record&.persisted?
    end
    blob&.purge_later
  end
  def variant(transformations, key)
    case transformations
    when Symbol
      variant_name = transformations
      transformations = variants.fetch(variant_name) do
        record_model_name = record.to_model.model_name.name
        raise ArgumentError, "Cannot find variant :#{variant_name} for #{record_model_name}##{name}"
      end
    end
    blob.variant(transformations, key)
  end
  private
    def analyze_blob_later
      blob.analyze_later unless blob.analyzed?
    end
    def mirror_blob_later
      blob.mirror_later
    end
    def purge_dependent_blob_later
      blob&.purge_later if dependent == :purge_later
    end
    def dependent
      record.attachment_reflections[name]&.options&.fetch(:dependent, nil)
    end
    def variants
      record.attachment_reflections[name]&.variants
    end
end
ActiveSupport.run_load_hooks :active_storage_attachment, ActiveStorage::Attachment