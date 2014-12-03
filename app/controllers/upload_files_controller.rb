class UploadFilesController < ApplicationController
  before_action :set_file, only: :destroy

  def create
    @file = UploadFile.new(upload_file_params)
    @file.save
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @file_id = @file.id
    @file.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def set_file
    @file = UploadFile.find(params[:id])
  end

  def upload_file_params
    params.require(:upload_file).permit(:image)
  end
end
