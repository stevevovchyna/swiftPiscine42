#
# Be sure to run `pod lib lint svovchyn2019.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'svovchyn2019'
  s.version          = '0.1.0'
  s.summary          = 'Educational project for the Unit Factory Swift Piscine'
  s.swift_version = '5.1'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Pod is created for the educational purposes and will be a platform for creating an app which is capable of creating articles for a personal notebook'

  s.homepage         = 'https://github.com/stevevovchyna'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'stevevovchyna' => 'steve.vovchyna@gmail.com' }
  s.source           = { :git => 'https://github.com/stevevovchyna/svovchyn2019.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'svovchyn2019/Classes/**/*'
  
  # s.resource_bundles = {
  #   'svovchyn2019' => ['svovchyn2019/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'CoreData'
  # s.dependency 'AFNetworking', '~> 2.3'
end
