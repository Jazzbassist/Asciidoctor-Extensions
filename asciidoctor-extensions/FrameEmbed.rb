require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'json'
h5p_file='./asciidoctor-extensions/H5PBlock.rb'
require h5p_file if File.file? h5p_file
include ::Asciidoctor

class FrameEmbed < H5PBlock
  @@text=[]
  @@title=""
  use_dsl
  named :iframe
  on_context :open
  parse_content_as :simple

  def process parent, reader, attrs
    super parent, reader, attrs
  end

  def getClass
    return :iframe
  end
  
  def parseLine line
    @@text.push line
  end

  def processData imagedata, title=""
    h5p=%({"width":"500px","height":"300px","minWidth":"400px","source":"#{@@text.join("")}","resizeSupported":true})
    @@text=[]
    return h5p
  end
end

