class RetryNotWorkingJob < ApplicationJob
  include AcidicJob::Mixin

  def perform
    if Rails.cache.read("job_has_run")
      Rails.logger.info "Job executed successfully."
    else
      Rails.cache.write("job_has_run", true)
      raise StandardError, "Simulated job failure"
    end
  end
end
