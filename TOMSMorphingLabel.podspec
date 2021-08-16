Pod::Spec.new do |s|
  s.name             = "TOMSMorphingLabel"
  s.version          = "0.5.1"
  s.summary          = "Configurable morphing transitions between text values of a label."
  s.homepage         = "https://github.com/TomKnig/TOMSMorphingLabel"
  s.license          = 'MIT'
  s.author           = { "TomKnig" => "hi@tomknig.de" }
  s.source           = { :git => "https://github.com/TomKnig/TOMSMorphingLabel.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/TomKnig'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = ['Sources/TOMSMorphingLabel/', 'Sources/TOMSMorphingLabel/include']
end
