class RetrievalHistoryJob < ActiveJob::Base
  # include HTTP request helpers
  include Networkable

  # include CouchDB helpers
  include Couchable

  queue_as :low_priority

  def perform(*args)
    rh_ids.each { | rh_id | remove_lagotto_data(rh_id) }
  end
end