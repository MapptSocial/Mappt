source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

def import_pods
    use_frameworks!
    pod 'Pager'
    pod 'Fusuma'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'Firebase/Core'
    pod 'Alamofire'
    pod 'AlamofireObjectMapper'
    pod 'SDWebImage'
    pod 'SpinKit', '~> 1.1'
    pod 'Google/SignIn'
    pod 'Firebase/Messaging'
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end

target 'Mappt' do
    import_pods
end
