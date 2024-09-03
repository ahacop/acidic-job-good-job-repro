class AwaitedJob < ApplicationJob
  include AcidicJob::Mixin

  def perform
  end
end
