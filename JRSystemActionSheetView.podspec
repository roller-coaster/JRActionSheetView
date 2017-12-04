Pod::Spec.new do |s|
s.name         = 'JRSystemActionSheetView'
s.version      = '1.0.1'
s.summary      = 'Media Editor (edit photo、edit video)'
s.homepage     = 'https://github.com/roller-coaster/JRActionSheetView'
s.license      = 'MIT'
s.author       = { 'djr' => 'dayflyking@163.com' }
s.platform     = :ios
s.ios.deployment_target = '7.0'
s.source       = { :git => 'https://github.com/roller-coaster/JRActionSheetView.git', :tag => s.version, :submodules => true }
s.requires_arc = true
s.source_files = 'JRSystemActionSheetView/CustomView/*.{h,m}'

end
