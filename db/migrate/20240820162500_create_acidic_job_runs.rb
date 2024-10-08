class CreateAcidicJobRuns < ActiveRecord::Migration[7.2]
  def change
    create_table :acidic_job_runs do |t|
      t.boolean     :staged, 					null: false,  default: -> { false }
      t.string      :idempotency_key, null: false,  index: { unique: true }
      t.text        :serialized_job, 	null: false
      t.string      :job_class, 			null: false
      t.datetime    :last_run_at, 		null: true,   default: -> { "CURRENT_TIMESTAMP" }
      t.datetime    :locked_at, 			null: true
      t.string      :recovery_point, 	null: true
      t.text        :error_object, 		null: true
      t.text        :attr_accessors, 	null: true
      t.text        :workflow, 				null: true
      t.references  :awaited_by,      null: true,   index: true
      t.text        :returning_to,    null: true
      t.timestamps
    end
  end
end
