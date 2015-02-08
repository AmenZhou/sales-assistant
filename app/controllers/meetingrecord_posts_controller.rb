class MeetingrecordPostsController < PostsController

  private

  def set_categories
    @categories = MeetingrecordCategory.all
  end
end
