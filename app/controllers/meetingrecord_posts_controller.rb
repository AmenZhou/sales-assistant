class MeetingrecordPostsController < PostsController
  def index
    super
    @categories = MeetingrecordCategory.all
  end
end
