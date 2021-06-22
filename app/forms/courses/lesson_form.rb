# frozen_string_literal: true

class Courses::LessonForm < BaseForm
  attribute :course_id
  attribute :hold_date
  attribute :start_time
  attribute :end_time
  attribute :attendances
  attribute :absences

  attr_accessor :students, :student_ids, :attendance_ids, :absence_ids, :old_absence_ids, :notes, :args

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
    self.args = params[:courses_lesson_form]
  end

  def load_association
    load_collection
    assign_association
  end

  def load_collection
    self.students = Student.active.joins(:student_courses).where(student_courses: { course_id: course_id,
                                                                                    deleted: false }).decorate
    self.student_ids = students.map(&:id)
  end

  def assign_association
    assign_old_absence if record.present?
    assign_attendance
    assign_absence_note
  end

  def assign_old_absence
    self.old_absence_ids = record.lesson_absences.active.map(&:student_id)
  end

  def assign_attendance
    if args&.dig(:attendance_ids).present?
      self.attendance_ids = args[:attendance_ids].reject { |c| c&.blank? }.map(&:to_i)
    elsif record.present?
      self.attendance_ids = student_ids - old_absence_ids
    end
  end

  def assign_absence_note
    if args&.dig(:notes).present?
      self.notes = args[:notes]
    elsif record.present?
      self.notes = {}
      record.lesson_absences.each do |absence|
        note = { 'note' => absence.note }
        notes[absence.student_id.to_s] = note
      end
    end
  end

  def persist!
    ActiveRecord::Base.transaction do
      init_association
      self.record = create! unless exist?
      update! if exist?
      save_association
    end
  end

  def init_association
    self.absence_ids = student_ids - attendance_ids
    self.attendances = attendance_ids.size
    self.absences = absence_ids.size
  end

  def create!
    Lesson.create!(course_id: course_id, hold_date: hold_date, attendances: attendances, absences: absences)
  end

  def update!
    record.update!(attributes_for_record)
  end

  def save_association
    create_lesson_absences! unless exist?
    update_lesson_absences! if exist?
    update_student_course_attendances!
    # update_notes!
  end

  def create_lesson_absences!
    absence_ids.each do |id|
      record.lesson_absences.find_or_create_by!(student_id: id).update!(deleted: false)
    end
  end

  def update_lesson_absences!
    create_lesson_absences!
    new_attendance_ids = attendance_ids & old_absence_ids
    new_attendance_ids.each do |id|
      record.lesson_absences.find_by!(student_id: id).update!(deleted: true)
    end
  end

  def update_student_course_attendances!
    lessons = Lesson.by_course(course_id)
    total_lessons = lessons.size
    lesson_ids = lessons.map(&:id)

    students.each do |student|
      student_course = student.student_courses.where(course_id: course_id, deleted: false).first
      total_absences = student.lesson_absences.active.where(lesson_id: lesson_ids).size
      student_course.update!(attendances: total_lessons - total_absences, absences: total_absences)
    end
  end

  # def update_notes!
  #   notes.each do |key, _value|
  #     note = record.lesson_absences.find_by(student_id: key.to_i)
  #     note&.update!(note: notes[key]['note'])
  #   end
  # end
end
