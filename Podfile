# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
# ignore all warnings from all dependencies
inhibit_all_warnings!

target 'CorkWeather' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Cork Weather
  pod 'SDWebImage'
  pod 'MBProgressHUD'
  pod 'GoogleMaps'
  pod 'GooglePlacePicker'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  
  #pod 'SWLogger', :path => '/Volumes/Code/personal/SWLogger'
  pod 'SWLogger'
  
  target "CorkWeatherTests" do
      inherit! :search_paths
  end
end

# Disable Code Coverage for Pods projects
post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
        end
    end
end
