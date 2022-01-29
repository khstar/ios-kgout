# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'KGout' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'RxCocoa'
  pod 'SwiftyGif'
  pod 'SDWebImage', '~>3.8'
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/Database'
  pod 'Firebase/Crashlytics'
  pod 'GoogleToolboxForMac'
  pod 'Google-Mobile-Ads-SDK'
  pod 'RxGesture' 
  pod 'PureLayout'
  pod 'Moya-SwiftyJSONMapper/RxSwift'
  # pod 'Fabric', '~> 1.10'
  pod 'SwiftyJSON', '~> 4.0'
end

deployment_target = '10.0'
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
      # config.build_settings['HEADER_SEARCH_PATHS'] << "${PODS_ROOT}/Headers/Public/${EXPO_CPP_HEADER_DIR}"
    end
  end
end

