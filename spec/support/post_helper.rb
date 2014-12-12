module PostRspecHelper
  def delete_uploaded_file
    find('#file_list li #delete_upload_file').click
  end

  def uploading_file
    within('.new_upload_file') do
      attach_file 'upload_file[image]', Rails.root + 'spec/factories/download.jpg'
      find("input[value='Upload File']").click
    end
  end
end
RSpec.configure do |config|
  config.include PostRspecHelper, type: :feature
end
