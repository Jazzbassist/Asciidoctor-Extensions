require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'json'
require 'net/http'
require 'uri'
require 'openssl'
h5p_file='./asciidoctor-extensions/H5PBlock.rb'
require h5p_file if File.file? h5p_file
include ::Asciidoctor


class CodeFrame < H5PBlock
Thebepage=""  #for python
#TODO add Thebepages for other kernels here
  @@text=[]
  @@id=""
  use_dsl
  named :code
  on_context :listing
  parse_content_as :simple

  def process parent, reader, attrs
    #TODO fetch and store thebe options here
    super parent, reader, attrs
  end

  def handleReader reader
    reader.read_lines #remove all lines from reader, have been read before via parseLine
    uploadData
    reader.restore_lines [
      %(++++),
      %(<iframe src="#{Thebepage}?id=#{@@id}"></iframe>),
      %(++++)
    ]
    return reader
  end

  def getClass
    return :code
  end
  
  def parseLine line
    @@text.push line
  end
  
  def createOutput
    python run code
    return code
  end
  
  def uploadData
    #push code to database
    uri = URI.parse("")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = ""
    request.body = ""
    request.body << @@text.join("\n")
    req_options = {
      use_ssl: uri.scheme == "https",
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
	#TODO: run code locally and push output to database
    # response.code
    # response.body
    if (response.code=="304")
      puts "code was already posted"
    end
    @@id=response.body
  end
  
  def processData imagedata, title=""
	#create iframe linking to php
	#TODO append fetched thebeoptions and use correct thebepage.
    h5p=%({"width":"500px","height":"700px","minWidth":"400px","source":"#{Thebepage}?id=#{@@id}","resizeSupported":true})
    @@text=[]
    @@id=""
    return h5p
  end
end

