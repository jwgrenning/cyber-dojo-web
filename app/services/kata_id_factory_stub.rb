
class KataIdFactoryStub

  def initialize(externals)
    @externals = externals
    # Note: app-controller tests can run across multiple
    # threads, each time recreating this Stub object.
    unless storer.kata_exists?(default_id)
      stub(default_id)
    end
  end

  def id
    @stubs.shift
  end

  def stub(*kata_ids)
    storer.validate(kata_ids)
    @stubs = kata_ids
  end

  private

  def default_id
    ENV['CYBER_DOJO_TEST_ID']
  end

  def storer
    @externals.storer
  end

end