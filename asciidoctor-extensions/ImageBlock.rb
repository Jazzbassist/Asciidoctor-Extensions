#don't create a new block, just handle with image:

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'json'
search_file='./asciidoctor-extensions/ImageSearch.rb'
require search_file if File.file? search_file
h5p_file='./asciidoctor-extensions/H5PBlock.rb'
require h5p_file if File.file? h5p_file
include ::Asciidoctor

class ImageBlock < H5PBlock
  use_dsl
  named :image
  on_context :open
  parse_content_as :simple

  def process parent, reader, attrs
    super parent, reader, attrs
  end

  def getClass
    return :image
  end
  
  def parseLine line
    unless line.empty?
      raise "imageblock should contain only one line, formatted like 'image:<filename>[]' "
    end
    #that line is caucht in h5pblock.rb and put into imagedata
  end

  def processData imagedata, title=""
    #this plugin contains no text by itself, all relevant data is contained in imagedata
    #puts imagedata
    h5p=imagedata.slice(/{"params":({.*}), "metadata":{.*}, "library":.*}/, 1) #select all between params and metadata
    #puts h5p
    return h5p
  end
end




#{"content":{"params":{"contentName":"Image","file":{"path":"images\/file-5d8c904b2bdc9.jpg","mime":"image\/jpeg","copyright":{"license":"U"},"width":3840,"height":2400},"alt":"View of an Eclipse","title":"As you can see, this is an eclipse"},"library":"H5P.Image 1.1","metadata":{"contentType":"Image","license":"U","title":"Untitled Image"},"subContentId":"5b0ba768-cdb2-46a7-9016-f2177c7e2902"},"useSeparator":"auto"},
