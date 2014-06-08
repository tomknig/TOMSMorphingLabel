Pod::Spec.new do |s|
  s.name             = "TOMSMorphingLabel"
  s.version          = 0.1.0
  s.summary          = "TOMSMorphingLabel is a custom Label that provides morphing transitions to new content."
  s.description      = <<-DESC
                       An optional longer description of TOMSMorphingLabel

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "http://EXAMPLE/NAME"
  s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "TomKnig" => "hi@tomknig.de" }
  s.source           = { :git => "https://github.com/TomKnig/TOMSMorphingLabel.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/TomKnig'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes'
end
