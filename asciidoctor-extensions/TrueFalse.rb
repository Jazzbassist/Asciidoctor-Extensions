require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'json'
search_file='./asciidoctor-extensions/ImageSearch.rb'
require search_file if File.file? search_file
h5p_file='./asciidoctor-extensions/H5PBlock.rb'
require h5p_file if File.file? h5p_file
include ::Asciidoctor

class TrueFalse < H5PBlock
  @@question=""
  @@correct=nil
  use_dsl
  named :truefalse
  on_context :open
  parse_content_as :simple

  def process parent, reader, attrs
    super parent, reader, attrs
  end

  def getClass
    return :truefalse
  end
  
  def parseLine line
    if line.empty?
    elsif line=="true"
      @@correct="true"
    elsif line=="false"
      @@correct="false"
    else
      @@question+=(line)
    end
  end

  def processData imagedata, title=""
    title=nil
    h5p=%({"media":) + imagedata + %(,"correct":") + @@correct + %(","l10n":{"trueText":"Yes","falseText":"No","score":"You got @score of @total points","checkAnswer":"Check","showSolutionButton":"Show solution","tryAgain":"Retry","wrongAnswerMessage":"Wrong answer","correctAnswerMessage":"Correct answer","scoreBarLabel":"You got :num out of :total points"},"behaviour":{"enableRetry":true,"enableSolutionsButton":true,"disableImageZooming":true,"confirmCheckDialog":false,"confirmRetryDialog":false,"autoCheck":false},"confirmCheck":{"header":"Finish ?","body":"Are you sure you wish to finish ?","cancelLabel":"Cancel","confirmLabel":"Finish"},"confirmRetry":{"header":"Retry ?","body":"Are you sure you wish to retry ?","cancelLabel":"Cancel","confirmLabel":"Confirm"},"question":"<p>) + @@question + %(<\\/p>\\n"})
    @@question=""
    @@correct=nil
    return h5p
  end
end
=begin
  def process parent, reader, attrs
    @@counter+=1
    question=""
    correct="false"
    lines=reader.lines
    imagedata=""
    while(!lines.empty?)
      thisline=lines[0]
      if thisline.start_with?("image:")
        imagedata=handleImage thisline, 'truefalse'
      elsif thisline=="true"
        correct="true"
      else
        question+=(thisline)
      end
      lines.shift
    end
    imagedata = imagedata==""? "{}" : imagedata
    

    h5p=%({"media":#{imagedata},"correct":"#{correct}","l10n":{"trueText":"Yes","falseText":"No","score":"You got @score of @total points","checkAnswer":"Check","showSolutionButton":"Show solution","tryAgain":"Retry","wrongAnswerMessage":"Wrong answer","correctAnswerMessage":"Correct answer","scoreBarLabel":"You got :num out of :total points"},"behaviour":{"enableRetry":true,"enableSolutionsButton":true,"disableImageZooming":true,"confirmCheckDialog":false,"confirmRetryDialog":false,"autoCheck":false},"confirmCheck":{"header":"Finish ?","body":"Are you sure you wish to finish ?","cancelLabel":"Cancel","confirmLabel":"Finish"},"confirmRetry":{"header":"Retry ?","body":"Are you sure you wish to retry ?","cancelLabel":"Cancel","confirmLabel":"Confirm"},"question":"<p>#{question}<\\/p>\\n"})

    File.open("H5PFactory/truefalse/content/content.json", 'w') { |file| file.write(h5p) }
    create_block parent, :open, reader.lines, attrs
  end
=end




