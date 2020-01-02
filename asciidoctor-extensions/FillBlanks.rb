	require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
	require 'json'
	search_file='./asciidoctor-extensions/ImageSearch.rb'
	require search_file if File.file? search_file
	h5p_file='./asciidoctor-extensions/H5PBlock.rb'
	require h5p_file if File.file? h5p_file
	include ::Asciidoctor
	class FillBlanks < H5PBlock
	  @@text=[]
	  use_dsl
	  named :fillblanks
	  on_context :open
	  parse_content_as :simple

	  def getClass
	    return :fillblanks
	  end

	  def process parent, reader, attrs
	    super parent, reader, attrs
	  end

	  def parseLine line
	    if line.empty?
	      @@text.push %(<\\/p>\\n","<p>)
	    else
	      @@text.push line
	    end
	  end

	  def processData imagedata, title=""
	    h5p=%({"questions":["<p>)+@@text.join("\\n")+%(<\\/p>"],"showSolutions":"Show solutions","tryAgain":"Try again","text":"<p>) + title + %(<\\/p>\\n","checkAnswer":"Check","notFilledOut":"Please fill in all blanks","behaviour":{"enableSolutionsButton":true,"autoCheck":true,"caseSensitive":false,"showSolutionsRequiresInput":true,"separateLines":false,"enableRetry":true,"disableImageZooming":true,"confirmCheckDialog":false,"confirmRetryDialog":false,"acceptSpellingErrors":false,"enableCheckButton":true},"answerIsCorrect":"&#039;:ans&#039; is correct","answerIsWrong":"&#039;:ans&#039; is wrong","answeredCorrectly":"Answered correctly","answeredIncorrectly":"Answered incorrectly","solutionLabel":"Correct answer:","inputLabel":"Blank input @num of @total","inputHasTipLabel":"Tip available","tipLabel":"Tip","confirmCheck":{"header":"Finish ?","body":"Are you sure you wish to finish ?","cancelLabel":"Cancel","confirmLabel":"Finish"},"confirmRetry":{"header":"Retry ?","body":"Are you sure you wish to retry ?","cancelLabel":"Cancel","confirmLabel":"Confirm"},"media":) + imagedata + %(,"overallFeedback":[{"from":0,"to":100,"feedback":"You got @score of @total blanks correct."}],"scoreBarLabel":"You got :num out of :total points"})
	    @@text=[]
	    return h5p
	  end
	end



