Pod::Spec.new do |s|
  s.name     = 'Nama-macOS'
  s.version  = '5.2.0'
  s.license  = 'MIT'
  s.summary  = 'faceunity nama macOS v5.2.0-dev'
  s.homepage = 'https://github.com/Faceunity/FULiveDemoMac/tree/dev'
  s.author   = { 'faceunity' => 'dev@faceunity.com' }
  s.platform     = :osx, "10.8"
  s.source   = { :git => 'https://github.com/Faceunity/FULiveDemoMac.git', :tag => 'v5.2.0-dev' }
  s.source_files = 'FULiveDemoMac/Faceunity/FaceUnity-SDK-Mac/**/*.{h,m}'
  s.resources = 'FULiveDemoMac/Faceunity/FaceUnity-SDK-Mac/**/*.{bundle}'
  s.osx.vendored_library = 'FULiveDemoMac/Faceunity/FaceUnity-SDK-Mac/libnama.a'
  s.requires_arc = true
  s.osx.frameworks   = ['OpenGL', 'Accelerate', 'CoreMedia', 'AVFoundation']
  s.libraries = ["c++"]
  end