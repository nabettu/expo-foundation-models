Pod::Spec.new do |s|
  s.name           = 'ExpoFoundationModels'
  s.version        = '0.1.1'
  s.summary        = 'Expo module for Apple Foundation Models'
  s.description    = 'On-device LLM using Apple Foundation Models framework (iOS 26+).'
  s.license        = 'MIT'
  s.author         = 'nabettu'
  s.homepage       = 'https://github.com/nabettu/expo-foundation-models'
  s.platforms      = { :ios => '15.1' }
  s.source         = { git: 'https://github.com/nabettu/expo-foundation-models.git', tag: "#{s.version}" }
  s.static_framework = true

  s.dependency 'ExpoModulesCore'

  s.source_files = '**/*.{h,m,mm,swift,hpp,cpp}'
end
