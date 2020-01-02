RUBY_ENGINE == 'opal' ? (require 'QuizBlock') : (require_relative 'QuizBlock')
RUBY_ENGINE == 'opal' ? (require 'MultiBlock') : (require_relative 'MultiBlock')
RUBY_ENGINE == 'opal' ? (require 'FillBlanks') : (require_relative 'FillBlanks')
RUBY_ENGINE == 'opal' ? (require 'TrueFalse') : (require_relative 'TrueFalse')
RUBY_ENGINE == 'opal' ? (require 'MarkWords') : (require_relative 'MarkWords')
RUBY_ENGINE == 'opal' ? (require 'DragText') : (require_relative 'DragText')
RUBY_ENGINE == 'opal' ? (require 'FrameEmbed') : (require_relative 'FrameEmbed')
RUBY_ENGINE == 'opal' ? (require 'ColumnBlock') : (require_relative 'ColumnBlock')
RUBY_ENGINE == 'opal' ? (require 'TextBlock') : (require_relative 'TextBlock')
RUBY_ENGINE == 'opal' ? (require 'NoBlock') : (require_relative 'NoBlock')
RUBY_ENGINE == 'opal' ? (require 'CodeFrame') : (require_relative 'CodeFrame')
RUBY_ENGINE == 'opal' ? (require 'StemBlock') : (require_relative 'StemBlock')
RUBY_ENGINE == 'opal' ? (require 'TableBlock') : (require_relative 'TableBlock')
RUBY_ENGINE == 'opal' ? (require 'ImageBlock') : (require_relative 'ImageBlock')




Extensions.register do
  if ((@document.basebackend? 'html') && (@document.backend=='html' || @document.backend=='html5'))
      block QuizBlock
      block MultiBlock
      block FillBlanks
      block TrueFalse
      block MarkWords
      block DragText
      block FrameEmbed
      block ColumnBlock
      block TextBlock
      block CodeFrame
      block NoBlock
      block StemBlock
      block TableBlock
      block ImageBlock
  elsif @document.backend=='pdf'
  end
end


