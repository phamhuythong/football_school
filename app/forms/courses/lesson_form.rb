# frozen_string_literal: true

class Courses::LessonForm < BaseForm
  attribute :course_id
  attribute :hold_date
  attribute :start_time
  attribute :end_time
  attribute :notes

  attr_accessor :record, :students, :attendance_ids, :absence_ids, :args

  validates :course_id, presence: true
  validates :hold_date, presence: true

  def self.build(params = {})
    instance = new

    if params[:id]
      instance.record = Lesson.find(params[:id])
      return nil if instance.record.blank?

      instance.restore_from_record
    end

    instance.assign_params(params)
    instance.load_association

    instance
  end

  def self.permitted_params(params)
    params.require(:courses_lesson_form).permit :id, :course_id, :hold_date, :start_time, :end_time, :lock_version,
                                                notes: [:note], attendance_ids: []
  end

  def assign_params(params)
    self.course_id = params[:course_id]
    self.attributes = Courses::LessonForm.permitted_params(params) if params[:courses_lesson_form].present?
    self.args = params[:courses_lesson_form] if params[:courses_lesson_form].present?
  end

  def load_association
    load_collection
    assign_association
  end

  def load_collection
    self.students = Student.active.joins(:student_courses).where(student_courses: { course_id: course_id,
                                                                                    deleted: false })
  end

  def assign_association
    if args&.dig(:attendance_ids).present?
      self.attendance_ids = args[:attendance_ids].reject { |c| c&.blank? }.map(&:to_i)
    elsif record.present?
      assign_attendance
      assign_absence_note
    end
  end

  def assign_attendance
    absence_ids = record.lesson_absences.active.map(&:student_id)
    self.attendance_ids = students.map(&:id) - absence_ids
  end

  def assign_absence_note
    self.notes = {}
    record.lesson_absences.each do |absence|
      note = {'note' => absence.note}
      self.notes["#{absence.student_id}"] = note
    end
  end

  def persist!
    ActiveRecord::Base.transaction do
      record = create! unless exist?
      record = update! if exist?
      save_association(record)
    end
  end

  def create!
    Lesson.create!(course_id: course_id, hold_date: hold_date)
  end

  def update!
    record.update!(attributes_for_active_record)
  end

  def save_association
    student_ids = students.map(&:id)
    absence_ids = student_ids - attendance_ids
    create_lesson_absences! and return unless exist?

    update_lesson_absences!
  end

  def create_lesson_absences!
    absence_ids.each do |id|
      note = notes[id.to_s]['note']
      absence = record.lesson_absences.find_or_create_by!(student_id: id)
      absence.update!(note: note, deleted: false)
    end
  end

  def update_lesson_absences!
    create_lesson_absences!
  end
end
