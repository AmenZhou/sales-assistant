class YelpGrabWorker
  include Sidekiq::Worker

  def perform(name, count)
    YelpGrab.grab
  end
end