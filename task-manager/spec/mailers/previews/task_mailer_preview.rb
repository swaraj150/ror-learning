# Preview all emails at http://localhost:3000/rails/mailers/task_mailer_mailer
class TaskMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/task_mailer_mailer/task_created
  def task_created
    TaskMailer.task_created
  end

end
