include ::Asciidoctor

class NoBlock < Extensions::BlockProcessor 
  use_dsl
  named :none
  parse_content_as :simple
  on_context :open

  def process parent, reader, attrs
    attrs["title"]=""
    return
#    create_block parent.parent,:open,"",attrs 
  end
end

class NoFBBlock < NoBlock
  named :fillblanks
end

class NoDTBlock < NoBlock
  named :dragtext
end
class NoQuizBlock < NoBlock
  named :quiz
  on_context :example
end
class NoMWBlock < NoBlock
  named :markwords
end
class NoTextBlock < NoBlock
  named :text
end
class NoFEBlock < NoBlock
  named :iframe
end

class NoColumnBlock < NoBlock
  named :column
  on_context :example
end

class NoMultiBlock < NoBlock
  named :multi
end

class NoTFBlock < NoBlock
  named :truefalse
end
