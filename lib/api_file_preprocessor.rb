class ApiFilePreprocessor
  attr_reader :params, :tempfile

  def initialize(params)
    @params = params
    @tempfile = Tempfile.new("file-#{Time.now}")
    @tempfile.binmode
  end

  def process
    tempfile.write Base64.decode64(params[:data])
    tempfile.rewind

    ActionDispatch::Http::UploadedFile.new(
      tempfile: tempfile,
      type: params[:content_type],
      filename: params[:file_name]
    )
  end

  def clean
    tempfile.close(true) if tempfile
  end
end
