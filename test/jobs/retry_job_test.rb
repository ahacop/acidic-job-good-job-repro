require "test_helper"

class RetryJobTest < ActiveSupport::TestCase
  setup do
    Rails.cache.clear
  end

  test "job with AcidicJob mixed in raises on retry with GoodJob" do
    not_working_job = RetryNotWorkingJob.perform_later
    working_job = RetryWorkingJob.perform_later

    assert_raises(StandardError) do
      GoodJob.perform_inline
    end

    assert_raises(StandardError) do
      GoodJob.perform_inline
    end

    not_working_gj = GoodJob::Job.find_by(active_job_id: not_working_job.job_id)
    assert_not_nil not_working_gj
    assert_equal 1, not_working_gj.executions.count
    assert_not_nil not_working_gj.executions.first.error

    working_gj = GoodJob::Job.find_by(active_job_id: working_job.job_id)
    assert_not_nil working_gj
    assert_equal 1, working_gj.executions.count
    assert_not_nil working_gj.executions.first.error

    assert_difference -> { working_gj.executions.count }, 1 do
      working_gj.retry_job
      GoodJob.perform_inline
    end

    assert_raises(NoMethodError, "undefined method `utc' for an instance of Float") do
      not_working_gj.retry_job
    end
  end
end
