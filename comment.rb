require './errors.rb'

class Comment

  def initialize(text)    
    raise InvalidPostOrComment if (text == nil)
    @text = text
  end

end