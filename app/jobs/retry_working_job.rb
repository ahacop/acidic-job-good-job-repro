class RetryWorkingJob < ApplicationJob
  def perform
    if Rails.cache.read("retry-working")
      Rails.logger.info "Job executed successfully."
    else
      Rails.cache.write("retry-working", true)
      raise StandardError, "Simulated job failure"
    end
  end
end
