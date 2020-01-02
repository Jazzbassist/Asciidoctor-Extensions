require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'json'
search_file='./asciidoctor-extensions/ImageSearch.rb'
require search_file if File.file? search_file
h5p_file='./asciidoctor-extensions/H5PBlock.rb'
require h5p_file if File.file? h5p_file
include ::Asciidoctor

class MarkWords < H5PBlock
  @@text=[]
  @@title=""
  use_dsl
  named :markwords
  on_context :open
  parse_content_as :simple

  def process parent, reader, attrs
    super parent, reader, attrs
  end

  def getClass
    return :markwords
  end
  
  def parseLine line
    if line.empty?
      @@text.push "<\\/p>\\n<p>"
    else
      @@text.push line
    end
  end

  def processData imagedata, title=""
    h5p=%({"checkAnswerButton":"Check","tryAgainButton":"Retry","showSolutionButton":"Show solution","behaviour":{"enableRetry":true,"enableSolutionsButton":true,"enableCheckButton":true,"showScorePoints":true},"taskDescription":"<p>) + title + %(<\\/p>\\n","textField":"<p>) + @@text.join("\\n") + %(<\\/p>","overallFeedback":[{"from":0,"to":100,"feedback":"You got @score of @total points."}],"correctAnswer":"Correct!","incorrectAnswer":"Incorrect!","missedAnswer":"Missed!","displaySolutionDescription":"Task is updated to contain the solution.","scoreBarLabel":"You got :num out of :total points"})
    @@text=[]
    return h5p
  end
end





