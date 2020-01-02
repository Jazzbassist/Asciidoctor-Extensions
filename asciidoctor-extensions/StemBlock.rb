require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'json'
search_file='./asciidoctor-extensions/ImageSearch.rb'
require search_file if File.file? search_file
h5p_file='./asciidoctor-extensions/H5PBlock.rb'
require h5p_file if File.file? h5p_file
include ::Asciidoctor


Url=""
class StemBlock < H5PBlock
  @@text=[]
  @@title=""
  @@id=""
  use_dsl
  named :math
  on_context :pass
  parse_content_as :simple

  def process parent, reader, attrs
    super parent, reader, attrs
  end

  def handleReader reader
    reader.read_lines #remove all lines from reader
    uploadData
    return reader
  end

  def getClass
    return :math
  end
  
  def parseLine line
    @@text.push line
  end
  
  def uploadData
    #push code to database
    uri = URI.parse("")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = ""
    request.body = ""
    request.body << createHTML
    #TODO: get an environment html to work so you only need to push the actual math instead of the same html around it everytime
    req_options = {
      use_ssl: uri.scheme == "https",
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    # response.code
    # response.body
    if (response.code=="304")
      puts "code was already posted"
    else
      #puts response.body
    end
    @@id=response.body
  end
  
  def processData imagedata, title=""

    
	#create iframe linking to php 

    h5p=%({"width":"500px","height":"300px","minWidth":"400px","source":"#{Url}/#{@@id}","resizeSupported":true})
    @@text=[]
    @@id=""
    return h5p
  end
  
  def createHTML
    html=
%(<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Untitled</title>
</head>
<body class="article">
<div class="stemblock">
<div class="content">
#{@@text.join("\n")}
</div>
</div>
<script type="text/x-mathjax-config">
MathJax.Hub.Config\({
  messageStyle: "none",
  tex2jax: {
    inlineMath: [["\\(", "\\)"]],
    displayMath: [["\\[", "\\]"]],
    ignoreClass: "nostem|nolatexmath"
  },
  asciimath2jax: {
    delimiters: [["\\$", "\\$"]],
    ignoreClass: "nostem|noasciimath"
  },
  TeX: { equationNumbers: { autoNumber: "none" } }
}\)
MathJax.Hub.Register.StartupHook\("AsciiMath Jax Ready", function () {
  MathJax.InputJax.AsciiMath.postfilterHooks.Add\(function (data, node) {
    if \((node = data.script.parentNode) && (node = node.parentNode) && node.classList.contains('stemblock')\) {
      data.math.root.display = "block"
    }
    return data
  }\)
}\)
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_HTMLorMML"></script>
</body>
</html>)
    return html
  end
end



