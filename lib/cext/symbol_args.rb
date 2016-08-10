# Symbol#args
class Symbol
  def args(*args_)
    ->(item) { item.send(self, *args_) }
  end
end
