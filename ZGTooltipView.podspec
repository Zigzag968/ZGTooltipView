#
# Be sure to run `pod lib lint ZGTooltipView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZGTooltipView'
  s.version          = '0.1.0'
  s.summary          = 'Tooltip View for iOS'

  s.description      = <<-DESC
Tooltip View for iOS
                       DESC

  s.homepage         = 'https://github.com/Zigzag968/ZGTooltipView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alexandre Guibert' => 'alexandre968@hotmail.com' }
  s.source           = { :git => 'https://github.com/Zigzag968/ZGTooltipView.git', :tag => v0.1 }

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZGTooltipView/Classes/**/*'

end
