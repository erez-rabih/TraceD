class FakeStatsdClient

  def increment(stat)
  end

  def time(stat)
    yield
  end
end
