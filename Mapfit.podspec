Pod::Spec.new do |s|

s.name         = "Mapfit"
s.version      = "1.1"

s.summary      = "Mapfit iOS SDK"
s.description  = 'The Mapfit iOS SDK packages up everything you need to use Mapfit services in your iOS applications. It also simplifies setup, installation, API key management, and generally makes your life better.'

s.homepage     = "https://mapfit.com/developers"
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.requires_arc = true
s.author         = { "Mapfit" => "zain@mapfit.com" }

s.platform     = :ios, "11.0"

s.source       = { :git => "https://github.com/mapfit/iOS-sdk.git", :tag => "1.1" }

s.dependency 'Tetragon-mobile'
s.source_files = ['iOS-SDK/*.swift', 'iOS-SDK/*/*.swift']

s.resource_bundles = { 'houseStyles' => ['iOS-SDK/houseStyles.bundle/**/*.*'] }

end
