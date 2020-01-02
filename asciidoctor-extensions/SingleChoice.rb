require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
h5p_file='./asciidoctor-extensions/H5PBlock.rb'
require h5p_file if File.file? h5p_file
require 'fileutils'
include ::Asciidoctor

class SingleChoice < H5PBlock
  @@counter=0
  use_dsl
  named :single
  on_context :open
  parse_content_as :simple
  @@question=""
  @@answers=[]

  def getClass
    return :single
  end

  def process parent, reader, attrs
    super parent, reader, attrs
  end

  def parseLine line
    if line.empty?
    elsif line.start_with?("- ")
      @@answers.push fluffanswer(line,line.end_with?("*"))
    elsif line.start_with?("-")
      raise "Incorrect Syntax in MultiBlock#{@@counter}: Please start each answer with a dash (-) followed by a space"
    else
      @@question=fluffquestion line
    end
  end

  def processData imagedata, title=""
    title=nil #use title for question?
    content=""
    for question in questions
    h5p = %({"choices":[{"answers":[") + answers.join(%(",")) + %("],"question":") + @@question + %(","subContentId":"51445ea9-9c98-437a-8981-72d46d6e86c4"},{"answers":["Asia","Africa","Europe"],"question":"Goji berries are native to ...","subContentId":"95b60491-e203-4bc5-956c-89e966b1005d"},{"answers":["Dried","Pickled","Frozen"],"question":"Goji berries are usually sold ...","subContentId":"aa694288-df4d-4ed3-8f81-f47fa3d27fe4"}],"behaviour":{"timeoutCorrect":1000,"timeoutWrong":1000,"soundEffectsEnabled":true,"enableRetry":true,"enableSolutionsButton":true,"passPercentage":100,"autoContinue":true},"l10n":{"showSolutionButtonLabel":"Show solution","retryButtonLabel":"Retry","solutionViewTitle":"Solution","correctText":"Correct!","incorrectText":"Incorrect!","muteButtonLabel":"Mute feedback sound","closeButtonLabel":"Close","slideOfTotal":"Slide :num of :total","nextButtonLabel":"Next question","scoreBarLabel":"You got :num out of :total points"},"overallFeedback":[{"from":0,"to":100,"feedback":"You got :numcorrect of :maxscore correct"}]})
    @@question=""
    @@answers=[]
    return h5p
  end

  def fluffquestion question
    return (%("question":"<p>)+question+%(<\\/p>\\n",))
  end

  def fluffanswer answer, correct
    return %({"correct":#{correct},"text":"<div>) + answer.delete_prefix("- ").delete_prefix("*").chomp('*') + %(<\\/div>\\n","tipsAndFeedback":{"tip":"","chosenFeedback":"","notChosenFeedback":""}})
  end
end
=begin
  def process parent, reader, attrs
    @@counter+=1
    FileUtils.mkdir_p %(H5PFactory/multi#{@@counter}/content/images)
    header=[%({"answers":[)]
    footer=[%(<input type="submit" value="Submit">),%(</form>),%(</div><br>),%(++++)]
    imagedata=""
    question = ""
    answers = Array.new
    correct = false
    lines=reader.lines
    question = fluffquestion(lines.shift)
    output=[]
    while(!lines.empty?)
      thisline=lines[0]
      if (thisline.empty?) #jump straight to next iteration
      elsif thisline.start_with?("image:")
        imagedata=handleImage thisline, "multi#{@@counter}"
      else
        if (thisline.end_with?("*")) #correct answer
          correct = true
        end
        answers.push( fluffanswer(thisline,correct) )
      end
      correct = false
      lines.shift
    end
    imagedata = imagedata==""? "{}" : imagedata
    h5p = %({"answers":[) + answers.join(",") + %(],"UI":{"showSolutionButton":"Show solution","tryAgainButton":"Retry","checkAnswerButton":"Check","tipsLabel":"Show tip","scoreBarLabel":"You got :num out of :total points","tipAvailable":"Tip available","feedbackAvailable":"Feedback available","readFeedback":"Read feedback","wrongAnswer":"Wrong answer","correctAnswer":"Correct answer","shouldCheck":"Should have been checked","shouldNotCheck":"Should not have been checked","noInput":"Please answer before viewing the solution"},) + question + %("behaviour":{"enableRetry":true,"enableSolutionsButton":true,"singlePoint":true,"randomAnswers":true,
"showSolutionsRequiresInput":true,"type":"auto","disableImageZooming":true,
"confirmCheckDialog":false,"confirmRetryDialog":false,"autoCheck":false,"passPercentage":100,"showScorePoints":true,"enableCheckButton":true},"media":#{imagedata},"confirmCheck":{"header":"Finish ?","body":"Are you sure you wish to finish ?","cancelLabel":"Cancel","confirmLabel":"Finish"},"confirmRetry":{"header":"Retry ?","body":"Are you sure you wish to retry ?","cancelLabel":"Cancel","confirmLabel":"Confirm"},"overallFeedback":[{ "from":0,"to":0,"feedback":"Wrong"},{ "from":1,"to":99,"feedback":"Almost!"},{ "from":100,"to":100,"feedback":"Correct!"}]})
    create_h5p_file h5p

    create_block parent, :open, reader.lines, attrs
  end

  
=end
