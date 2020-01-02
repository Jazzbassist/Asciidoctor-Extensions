require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'json'
h5p_file='./asciidoctor-extensions/H5PBlock.rb'
require h5p_file if File.file? h5p_file
include ::Asciidoctor

class ColumnBlock < H5PBlock
  use_dsl
  named :column
  on_context :example
  parse_content_as :compound
  @@questions=[]
  @@itemcounter=0
  @@container=""
  
  def parseLine line
    if ((/\[[\w, ]*\]/.match? line) &! (line == "[stem]") &! line.include?("=")) #check for [fillblanks], [multi], etc., also account for attributes
      #puts line
      @@itemcounter+=1
      if @@container==""
        plugin=line.delete_prefix('[').delete_suffix(']').gsub(/(, \w*)*/, "")
        @@questions.push [plugin,((getCounter+@@itemcounter).to_s)] #push keyword without brackets and without comma
      end
    elsif /====/.match? line #blocks between will be parsed into another block
      if @@container=="" #following blocks will be parsed into another block
        @@container = line
      elsif @@container==line #ending delimiter found
        @@container =""
      end #else another block is nested within nested block
    end
  end

  def getClass
    return :column
  end

  def processData imagedata, title=""
    title=nil
    content=""
    counter=0
    for question in @@questions do
      #puts question
      begin
        file = File.open "H5PFactory/#{question.join("")}/content/content.json"
      rescue
        raise "The file H5PFactory/#{question.join("")}/content/content.json does not exist. Did you make #{question.join} known to CompleteBuilder.rb?"
      end
      content+=%({"content":{"params":) + JSON.load(file).to_s.gsub(/=>/,":") + %(,"library":") + getLibrary(question[0]) + %(","subContentId":"#{counter}","metadata": {"title":")+question[0]+%(\\n"}},"useSeparator":"auto"},)
      counter+=1
    end
    content.chomp!(",") #remove last comma
    h5p=%({"content":[) + content + %(]})
  #  emptyb = create_block parent, :example, [], attrs
    @@questions=[]
    @@itemcounter=0
    return h5p
  end

end
   # {"progressType": "dots","passPercentage": 50,"questions": [{"params": #{multicontent.json},"library": "H5P.MultiChoice 1.13","subContentId": "bd03477a-90a1-486d-890b-0657d6e80ffd","metadata": {"title": "Which of the berries listed below&nbsp;are berries you can pick in the wild?\n"}},{"params": {#{dragandrop.json},"library": "H5P.DragQuestion 1.13","subContentId": "14fcc986-728b-47f3-915b-6db2fc050537","metadata": {"title": "Drag and drop"}},{"params": #{multiplechoice.json},"library": "H5P.MultiChoice 1.13","subContentId": "28825d6e-be6e-404c-be6d-344ab504e11c","metadata": {"title": "Which one of the following berries are red?\n"}}],"introPage": {"showIntroPage": false,"startButtonText": "Start Quiz","introduction": ""},"texts": {"prevButton": "Previous","nextButton": "Next","finishButton": "Finish","textualProgress": "Question: @current of @total questions","questionLabel": "Question","jumpToQuestion": "Jump to question %d","readSpeakerProgress": "Question @current of @total","unansweredText": "Unanswered","answeredText": "Answered","currentQuestionText": "Current question"},"endGame": {"showResultPage": true,"solutionButtonText": "Show solution","finishButtonText": "Finish","showAnimations": false,"skippable": false,"skipButtonText": "Skip video","message": "Your result:","retryButtonText": "Retry","noResultMessage": "Finished","overallFeedback": [{"from": 0,"to": 100,"feedback": "You got @score points of @total possible."}],"oldFeedback": {"successGreeting": "Congratulations!","successComment": "You did very well!","failGreeting": "Oh, no!","failComment": "This didn't go so well."},"showSolutionButton": true},"override": {"showSolutionButton": "off","retryButton": "off","checkButton": true},"disableBackwardsNavigation": false,"randomQuestions": false}
