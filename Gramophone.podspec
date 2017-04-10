Pod::Spec.new do |s|
  s.name = 'Gramophone'
  s.version = '1.0'
  s.summary = 'Gramophone is a swifty wrapper of the Instagram API'
  s.homepage = 'https://github.com/jverdi/Gramophone'
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.authors = { 'Jared Verdi' => 'jared@jaredverdi.com' }
  s.social_media_url = 'http://twitter.com/jverdi'

  s.source = { :git => 'https://github.com/jverdi/Gramophone.git', :tag => s.version }
  s.source_files = 'Source/*.swift', 'Source/Client/*.swift', 'Source/Model/*.swift', 'Source/Resources/*.swift'

  s.ios.deployment_target = '9.0'

  s.dependency 'Result', '~> 3.2'
  s.dependency 'Decodable', '~> 0.5'
end
