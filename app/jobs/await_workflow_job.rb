class AwaitWorkflowJob < ApplicationJob
  include AcidicJob::Mixin

  def perform
    with_acidic_workflow do |w|
      w.step :waiting_step, awaits: [ AwaitedJob ]
    end
  end
end
