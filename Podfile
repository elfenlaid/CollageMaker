platform :ios, '11.0'
use_frameworks!

def defaults
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'SnapKit'
    pod 'R.swift'
end

target 'CollageMaker' do
  defaults
  
  target 'CollageMakerUITests' do
      inherit! :search_paths
  end
  
  target 'CollageMakerTests' do
      inherit! :search_paths
  end
end


