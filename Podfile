# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'KGout' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'RxCocoa'
  pod 'SwiftyGif'
  pod 'SDWebImage', '~>3.8'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Database'
  pod 'Google-Mobile-Ads-SDK'
  pod 'RxGesture' 
  pod 'PureLayout'
  pod 'Moya-SwiftyJSONMapper/RxSwift'
  pod 'PureLayout'
  pod 'Fabric', '~> 1.7.6'
  pod 'Crashlytics', '~> 3.10.1'
  pod 'GoogleToolboxForMac', '~> 2.1'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
