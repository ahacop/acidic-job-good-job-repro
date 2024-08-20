require "test_helper"

class RetryJobTest < ActiveSupport::TestCase
  setup do
    Rails.cache.clear
  end

  test "job can be retried after failure" do
    # Enqueue the job that will raise an error
    job = RetryJob.perform_later

    # Simulate job failure by calling GoodJob's ability to execute jobs
    assert_raises(StandardError) do
      GoodJob.perform_inline
    end

    # Find the GoodJob::Job associated with the ActiveJob
    good_job = GoodJob::Job.find_by(active_job_id: job.job_id)
    assert_not_nil good_job

    # Assert that the initial execution has failed
    initial_execution = GoodJob::Execution.find_by(active_job_id: job.job_id)
    assert_not_nil initial_execution
    assert_not_nil initial_execution.error

    # Retry the failed job
    assert_difference -> { GoodJob::Execution.count }, 1 do
      good_job.retry_job
      GoodJob.perform_inline
    end

    # Verify that a new execution was created and that it succeeded
    retried_execution = GoodJob::Execution.where(active_job_id: job.job_id).order(created_at: :desc).first
    assert_not_equal initial_execution.id, retried_execution.id
    assert_nil retried_execution.error
  end
end
