class SelectiveAssetsCompressor < Uglifier
  def initialize(options = {})
    super(options)
  end

  def compress(string)
    if string =~ /CKSource/
      string
    else
      super(string)
    end
  end
end