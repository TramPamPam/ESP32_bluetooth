platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'Moya', '~> 10.0.0'
  pod 'PromiseKit', '~> 6.0'
  pod 'netfox', ' ~> 1.11.0'
  pod 'SDWebImage', '~> 4.0'
  pod "JoystickView"
end

target 'Zori' do
  shared_pods
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '4.1'
          end
      end
  end

end

target 'ZoriTests' do 
  shared_pods
end

