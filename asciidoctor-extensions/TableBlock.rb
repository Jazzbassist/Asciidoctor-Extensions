require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'json'
search_file='./asciidoctor-extensions/ImageSearch.rb'
require search_file if File.file? search_file
h5p_file='./asciidoctor-extensions/H5PBlock.rb'
require h5p_file if File.file? h5p_file
include ::Asciidoctor

class TableBlock < H5PBlock
  @@text=""
  @@title=""
  named:mytable
  on_context :table
  parse_content_as :simple

  def process parent, reader, attrs
    super parent, reader, attrs
  end

  def handleReader reader 
    #dirty way of telling asciidoctor to process it as it would normally have and store it in @text
    @@text = ( Asciidoctor.convert(%(|===\n#{reader.lines.join("\n")}\n|===)) ).gsub(%("),%(\\")).gsub(%(\n),%(\\n))
    return reader
    #let asciidoctor run over reader
    #save result
  end
  
  def getClass
    return :mytable
  end
  
  def parseLine line
    return
  end

  def processData imagedata, title=""
    h5p=%({"text":") + @@text + %("})
    @@text=""
    return h5p
  end
end


=begin

{"content":[
	{"content":{"params":
		{
			"text":"<p>text<\/p>\n\n<ul>\n\t<li>bulletpoint 1<\/li>\n\t<li>bullet 2\n\t<ul>\n\t\t<li>bullet 2.1<\/li>\n\t<\/ul>\n\t<\/li>\n<\/ul>\n\n<p>text<\/p>\n\n<p>&nbsp;<\/p>\n"
		},
			"library":"H5P.AdvancedText 1.1","metadata":{"contentType":"Text","license":"U","title":"Untitled Text"},"subContentId":"17a0cd84-4485-4792-b5ca-8b025e4e75ef"},"useSeparator":"auto"},
	{"content":{"params":
		{
			"text":"<table class=\"h5p-table\">\n\t<thead>\n\t\t<tr>\n\t\t\t<th scope=\"col\">Heading Column 1<\/th>\n\t\t\t<th scope=\"col\">Heading Column 2<\/th>\n\t\t<\/tr>\n\t<\/thead>\n\t<tbody>\n\t\t<tr>\n\t\t\t<td>Row 1 Col 1<\/td>\n\t\t\t<td>Row 1 Col 2<\/td>\n\t\t<\/tr>\n\t\t<tr>\n\t\t\t<td>Row 2 Col 1<\/td>\n\t\t\t<td>Row 2 Col 2<\/td>\n\t\t<\/tr>\n\t<\/tbody>\n<\/table>\n"
		},
		"library":"H5P.Table 1.1","metadata":{"contentType":"Table","license":"U","title":"Untitled Table"},"subContentId":"535c277e-4a8e-44d3-945b-2481e24ccce2"},"useSeparator":"auto"}]}
=end
