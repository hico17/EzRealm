Pod::Spec.new do |spec|
  spec.name             = 'EzRealm'
  spec.version          = '0.1.0'
  spec.summary          = 'An easy way of managing Realms objects.'
 
  spec.description      = <<-DESC
  Protocol oriented Realms
  Easily create, save, delete, update your Realm Object Classes synchronously.
  Access delegate methods as "willDeleteOnRealm" or "didMakeARealmCall" in a Swifty familiar way.
  No more thread problems.
                         DESC
 
  spec.homepage         = 'https://github.com/hico17/EzRealm'
  spec.license          = { :type => 'MIT', :file => '../LICENSE' }
  spec.author           = { 'Hico' => 'lucaceldev@gmail.com' }
  spec.source           = { :git => 'https://github.com/hico17/EzRealm.git', :tag => spec.version.to_s }
 
  spec.ios.deployment_target = '10.0'
  spec.swift_versions = ['4', '4.2', '5']
  spec.source_files = 'EzRealm/Source/**/*.swift'
  # spec.resources = "EzRealm/Source/**/*.{storyboard,xib,xcassets}"
  spec.dependency 'RealmSwift'
end
