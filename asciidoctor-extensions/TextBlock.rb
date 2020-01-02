require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'json'
search_file='./asciidoctor-extensions/ImageSearch.rb'
require search_file if File.file? search_file
h5p_file='./asciidoctor-extensions/H5PBlock.rb'
require h5p_file if File.file? h5p_file
include ::Asciidoctor

class TextBlock < H5PBlock
  @@text=[]
  @@title=""
  use_dsl
  named :text
  on_context :open
  parse_content_as :simple

  def process parent, reader, attrs
    super parent, reader, attrs
  end

  def getClass
    return :text
  end
  
  def parseLine line
    if line.empty?
      @@text.push "<\\/p>\\n\\n<p>"
    else
      @@text.push line
    end
  end

  def processData imagedata, title=""
    h5p=%({"text":"<p>) + @@text.join("") + %(<\\/p>\\n"})
    @@text=[]
    return h5p
  end
end





