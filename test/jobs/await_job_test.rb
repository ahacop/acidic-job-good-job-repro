require "test_helper"
require "acidic_job/testing"

class AwaitJobTest < ActiveSupport::TestCase
  include AcidicJob::Testing

  test "await step raises RuntimeError with GoodJob" do
    AwaitWorkflowJob.perform_later
    assert_raises(RuntimeError, "This should be equal.") do
      GoodJob.perform_inline
    end
  end
end
