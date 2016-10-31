source 'https://github.com/CocoaPods/Specs.git'
platform :ios, :deployment_target => '8.0'
use_frameworks!

target 'Menza' do
	pod 'Alamofire', '~> 3.5'
	pod 'SwiftyJSON', '~> 2.4.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3' # or '3.0'
    end
  end
end
