Pod::Spec.new do |s|
  s.name           = 'ExpoAppleLLM'
  s.version        = '0.2.0'
  s.summary        = 'Expo module for Apple on-device LLM'
  s.description    = 'On-device LLM using Apple Foundation Models framework (iOS 26+).'
  s.license        = 'MIT'
  s.author         = 'nabettu'
  s.homepage       = 'https://github.com/nabettu/expo-apple-llm'
  s.platforms      = { :ios => '15.1' }
  s.source         = { git: 'https://github.com/nabettu/expo-apple-llm.git', tag: "#{s.version}" }
  s.static_framework = true

  s.dependency 'ExpoModulesCore'

  s.source_files = '**/*.{h,m,mm,swift,hpp,cpp}'
end
