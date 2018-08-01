platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'Moya', '~> 10.0.0'
  pod 'PromiseKit', '~> 6.0'
end

target 'Zori' do
  pod 'netfox', '~> 1.10'
  shared_pods
end

target 'ZoriTests' do 
  shared_pods
end

