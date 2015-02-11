class YelpGrabWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(name, count)
    YelpGrab.grab
  end
end