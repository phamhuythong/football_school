class AddDeleted < ActiveRecord::Migration[6.0]
  def change
    rename_column :lesson_absences, :reason, :note
    add_column :lesson_absences, :deleted, :boolean, default: false
  end
end
