class UploadFilesController < ApplicationController
  def create
    @file = UploadFile.new(upload_file_params)
    @file.save
    #respond_to do |format|
      #format.js
    #end
  end

  private

  def upload_file_params
    params.require(:upload_file).permit(:image)
  end
end
