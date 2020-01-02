require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
search_file='./asciidoctor-extensions/ImageSearch.rb'
require search_file if File.file? search_file
super_file='./asciidoctor-extensions/LearnBlock.rb'
require super_file if File.file? super_file
include ::Asciidoctor

class H5PBlock < LearnBlock
  @@counter=0
  use_dsl


  def getLibrary ctype
    library=""
    case ctype
    when "multi"
      library="H5P.MultiChoice 1.13"
    when "fillblanks"
      library="H5P.Blanks 1.11"
    when "truefalse"
      library="H5P.TrueFalse 1.5"
    when "markwords"
      library="H5P.MarkTheWords 1.9"
    when "quiz"
      library="H5P.QuestionSet 1.16"
    when "iframe","code","math"
      library="H5P.IFrameEmbed 1.0"
    when "dragtext"
      library="H5P.DragText 1.8"
    when "text"
      library="H5P.AdvancedText 1.1"
    when "image"
      library="H5P.Image 1.1"
    when "mytable"
      library="H5P.Table 1.1"
      
    else 
      raise "content type #{ctype} not recognized. If #{ctype} is a new content type please add the corresponding library to H5PBlock:getLibrary"
    end
    return library
  end

  def getBlockType
    name=getClass
    if name == :column || name == :quiz
      return :example
    else
      return :open
    end
  end

  def needtobuild? parent, attrs
    doc=parent.document
    target=doc.attributes["target"]
    bool= (target==nil || attrs.has_value?(target))
    return bool
  end
  
  def process parent, reader, attrs
    unless needtobuild? parent, attrs
      attrs["title"]=""
      return
    end
    mycounter=incCounter
    imagedata="{}"
    FileUtils.mkdir_p %(H5PFactory/#{getName}/content/images)
    lines=reader.lines
    while(!lines.empty?)
      thisline=lines[0]
      if thisline.start_with?("image:")
        imagedata=handleImage thisline, getName
      else
        parseLine thisline
      end
      lines.shift
    end
    reader=handleReader reader
    block=create_block parent, :open, [], attrs   
    	#create empty block with title as given in attrs
    title=attrs.delete("title")
    parsed=parse_content block, reader, attrs
    	#content is parsed into block, now updated question blocks are available in storage
    h5p=processData imagedata, title==nil ? "" : title
    docname = getAttr("docname",parent)
    create_h5p_file h5p, mycounter, docname
    return parsed
  end

  def handleReader reader
    return reader
  end

  def getCounter
    return @@counter
  end

  def incCounter
    return @@counter+=1
  end

  def create_h5p_file h5p,cnt,docname
    if File.file? "H5PFactory/conffiles/#{getClass}.json"
      FileUtils.cp "H5PFactory/conffiles/#{getClass}.json", "H5PFactory/#{getClass}#{cnt}/h5p.json"
    else
      raise "Please provide a h5p.json file in conffiles for #{self.class} and rename it to #{getClass}.json"
    end
    thisfile="#{getClass}#{cnt}"
    File.open(%(H5PFactory/#{thisfile}.h5p), 'w')
    File.open("H5PFactory/#{thisfile}/content/content.json", 'w') { |file| 
      file.write(h5p) 
    }
    #Zip Files to create h5p File
    system("cd H5PFactory/#{thisfile}; zip -Dqr #{thisfile}.h5p content h5p.json")
    FileUtils.mkdir_p %(out/h5p/#{docname})
    FileUtils.cp "H5PFactory/#{thisfile}/#{thisfile}.h5p", "out/h5p/#{docname}/#{thisfile}.h5p"

  end

  def parseLine line
    raise ::NotImplementedError, %(#{H5PBlock} subclass #{self.class} must implement the ##{__method__} method)
  end

  def processData imagedata, title
    raise ::NotImplementedError, %(#{H5PBlock} subclass #{self.class} must implement the ##{__method__} method)
  end

  def getClass
    raise ::NotImplementedError, %(#{H5PBlock} subclass #{self.class} must implement the ##{__method__} method)
  end

  def getName
    return %(#{getClass}#{@@counter})
  end

end


