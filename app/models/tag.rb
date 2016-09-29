
class Tag

  def initialize(avatar, hash)
    @avatar = avatar
    @hash = hash
  end

  # queries

  attr_reader :avatar

  def parent
    avatar
  end

  def visible_files
    @manifest ||= storer.tag_visible_files(avatar.kata.id, avatar.name, number)
  end

  def output
    # Very early dojos didn't store output in initial tag 0
    visible_files['output'] || ''
  end

  def time
    Time.mktime(*hash['time'])
  end

  def light?
    colour.to_s != ''
  end

  def colour
    # Very early dojos used outcome
    (hash['colour'] || hash['outcome'] || '').to_sym
  end

  def to_json
    # Used only in differ_controller.rb
    {
      'colour' => colour,
      'time'   => time,
      'number' => number
    }
  end

  def number
    hash['number']
  end

  private

  include NearestAncestors

  attr_reader :hash

  def storer; nearest_ancestors(:storer); end

end
