Pod::Spec.new do |s|
  s.name     = 'Nama-macOS-lite'
  s.version  = '6.0.0'
  s.license  = 'MIT'
  s.summary  = 'faceunity nama macOS v6.0.0-lite'
  s.homepage = 'https://github.com/Faceunity/FULiveDemoMac'
  s.author   = { 'faceunity' => 'dev@faceunity.com' }
  s.platform     = :osx, "10.8"
  s.source   = { "http": "https://www.faceunity.com/sdk/FaceUnity-SDK-Mac-v6.0.0-lite.zip"}
  s.source_files = '**/*.{h,m}'
  s.resources = '**/*.{bundle,txt}'
  s.osx.vendored_library = '**/libnama.a'
  s.requires_arc = true
  s.osx.frameworks   = ['OpenGL', 'Accelerate', 'CoreMedia', 'AVFoundation']
  s.libraries = ["c++"]
  end