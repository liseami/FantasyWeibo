# Uncomment the next line to define a global platform for your project

platform :ios, '14.1'

target 'FantasyWeibo (iOS)' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FantasyWeibo (iOS)


pod 'Introspect'
pod 'lottie-ios'
pod 'CropViewController'
pod 'FloatingPanel'


pod 'UMCommon'
pod 'UMDevice'
pod 'UMCCommonLog'


pod 'FantasyUI', :path => './FantasyUI'

pod 'SDWebImageSwiftUI'

pod "Weibo_SDK", :git => "https://github.com/sinaweibosdk/weibo_ios_sdk.git" 



pod 'ActiveLabel'
pod 'BSText'

end


post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end