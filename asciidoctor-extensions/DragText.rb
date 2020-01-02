require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'json'
search_file='./asciidoctor-extensions/ImageSearch.rb'
require search_file if File.file? search_file
h5p_file='./asciidoctor-extensions/H5PBlock.rb'
require h5p_file if File.file? h5p_file
include ::Asciidoctor

class DragText < H5PBlock
  @@text=[]
  @@title=""
  use_dsl
  named :dragtext
  on_context :open
  parse_content_as :simple

  def process parent, reader, attrs
    super parent, reader, attrs
  end

  def getClass
    return :dragtext
  end
  
  def parseLine line
    if line.empty?
      @@text.push "<\\/p>\\n<p>"
    else
      @@text.push line
    end
  end

  def processData imagedata, title=""
    h5p=%({"taskDescription":"<p>) + title + %(<\\/p>\\n","checkAnswer":"Check","tryAgain":"Retry","showSolution":"Show Solution","behaviour":{"enableRetry":true,"enableSolutionsButton":true,"instantFeedback":false,"enableCheckButton":true},"textField":") + @@text.join("\\n") + %(","overallFeedback":[{"from":0,"to":100,"feedback":"Score: @score of @total."}],"dropZoneIndex":"Drop Zone @index.","empty":"Drop Zone @index is empty.","contains":"Drop Zone @index contains draggable @draggable.","draggableIndex":"Draggable @text. @index of @count draggables.","tipLabel":"Show tip","correctText":"Correct!","incorrectText":"Incorrect!","resetDropTitle":"Reset drop","resetDropDescription":"Are you sure you want to reset this drop zone?","grabbed":"Draggable is grabbed.","cancelledDragging":"Cancelled dragging.","correctAnswer":"Correct answer:","feedbackHeader":"Feedback","scoreBarLabel":"You got :num out of :total points"})
    @@text=[]
    return h5p
  end
end





