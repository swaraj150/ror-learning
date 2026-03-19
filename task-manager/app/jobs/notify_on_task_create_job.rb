class NotifyOnTaskCreateJob < ApplicationJob
  queue_as :default

  discard_on ActiveRecord::RecordNotFound do |job, error|
    Rails.logger.warn("Task not found, discarding job: #{error.message}")
  end


  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  def perform(task_id)
    task = Task.find_by(id: task_id)
    return unless task
    TaskMailer.task_created(task).deliver_now
  end
end
