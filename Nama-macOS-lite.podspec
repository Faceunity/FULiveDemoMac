Pod::Spec.new do |s|
  s.name     = 'Nama-macOS-lite'
  s.version  = '5.0'
  s.license  = 'MIT'
  s.summary  = 'faceunity nama macOS v5.0-dev-lite'
  s.homepage = 'https://github.com/Faceunity/FULiveDemoMac/tree/dev'
  s.author   = { 'faceunity' => 'dev@faceunity.com' }
  s.platform     = :osx, "10.8"
  s.source   = { :git => 'https://github.com/Faceunity/FULiveDemoMac.git', :tag => 'v5.0-dev' }
  s.source_files = 'FULiveDemoMac/Faceunity/FaceUnity-SDK-Mac-lite/**/*.{h,m}'
  s.resources = 'FULiveDemoMac/Faceunity/FaceUnity-SDK-Mac-lite/**/*.{bundle}'
  s.osx.vendored_library = 'FULiveDemoMac/Faceunity/FaceUnity-SDK-Mac-lite/libnama.a'
  s.requires_arc = true
  s.osx.frameworks   = ['OpenGL', 'Accelerate', 'CoreMedia', 'AVFoundation']
  s.libraries = ["c++"]
  end