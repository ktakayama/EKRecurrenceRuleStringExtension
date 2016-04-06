Pod::Spec.new do |s|
  s.name             = "EKRecurrenceRuleStringExtension"
  s.version          = "1.0.1"
  s.summary          = "EKRecurrenceRule extension in swift"
  s.homepage         = "https://github.com/ktakayama/EKRecurrenceRuleStringExtension"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Kyosuke Takayama" => "loiseau@gmail.com" }
  s.source           = { :git => "https://github.com/ktakayama/EKRecurrenceRuleStringExtension.git", :tag => s.version }
  s.social_media_url = 'https://twitter.com/takayama'

  s.ios.deployment_target = "8.0"
  s.requires_arc = true

  s.source_files = 'Sources/*.swift'
end
