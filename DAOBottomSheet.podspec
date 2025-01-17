#
# Be sure to run `pod lib lint DAOBottomSheet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DAOBottomSheet'
  s.version          = '1.3.1'
  s.summary          = 'A navigatable bottom sheet that can put your custom content inside.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A navigatable bottom sheet that can put your custom content inside.
you can customize bottom sheet height or let it fit to the content automatically.
                       DESC

  s.homepage         = 'https://github.com/daoseng33/DAOBottomSheet'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'daoseng33' => 'daoseng33@gmail.com' }
  s.source           = { :git => 'https://github.com/daoseng33/DAOBottomSheet.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '15.0'

  s.source_files = 'DAOBottomSheet/Classes/**/*'
  
  s.resource_bundles = {
    'DAOBottomSheet' => ['DAOBottomSheet/Assets/*.xcassets']
  }

  s.swift_version = '5.0'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
end
