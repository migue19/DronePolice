# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'DronePolice' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'CryptoSwift'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Auth'
  pod 'GoogleSignIn'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'ConnectionLayer'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      end
    end
  end
  
end
