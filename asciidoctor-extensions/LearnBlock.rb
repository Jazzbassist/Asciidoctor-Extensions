require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
search_file='./asciidoctor-extensions/ImageSearch.rb'
require search_file if File.file? search_file
include ::Asciidoctor

class LearnBlock < Extensions::BlockProcessor  

  def getAttr att, parent
    if parent.attr?(att)
      return parent.attr(att)
    elsif parent.respond_to? :parent and parent.parent.class != NilClass
      return getAttr(att, parent.parent)
    else
      return false
    end
  end

  
  def needtobuild? parent, block
    #check attribute of current block, compare with build attribute set and feedback accordingly
    #if getAttr(:uebung)
   #   return true if block==:h5p
    return false
  end

end
