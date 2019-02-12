#
# Be sure to run `pod lib lint JCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JCore'
  s.version          = '0.1.1'
  s.summary          = 'iOS项目常用封装（Objective-C）'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        iOS项目常用工具库，网络请求库，常用view
                       DESC

  s.homepage         = 'https://github.com/liresidue/JCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hitter' => 'liresidue@gmail.com' }
  s.source           = { :git => 'https://github.com/liresidue/JCore.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  
  s.default_subspec = 'JRequest'
  
  # 工具库
  s.subspec "JTools" do |ss|
      ss.source_files  = "JCore/JTools/**/*"
  end
  
  # 网络库
  s.subspec "JRequest" do |ss|
      ss.source_files = "JCore/JRequest/**/*"
      # ss.dependency "Moya", "~> 10.0"
      # ss.framework  = "UIKit"
  end
  
  # 控件库
  s.subspec "JView" do |ss|
      ss.source_files = "JCore/JView/**/*"
  end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
