# frozen_string_literal: true

class CourseDecorator < ApplicationDecorator
  delegate_all

  def teachers_by_ids
    teacher_courses_ids = teacher_courses.select { |tc| tc.deleted == false }.map(&:teacher_id)
    teachers.select { |t| teacher_courses_ids.include?(t.id) }.map(&:first_name).join(', ')
  end
end
