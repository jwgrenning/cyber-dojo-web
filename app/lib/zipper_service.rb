require_relative 'http_service'

class ZipperService

  def initialize(_parent)
  end

  def zip(kata_id)
    http_get(__method__, kata_id)
  end

  def zip_tag(kata_id, avatar_name, tag)
    http_get(__method__, kata_id, avatar_name, tag)
  end

  private

  include HttpService
  def hostname; 'zipper'; end
  def port; 4587; end

end