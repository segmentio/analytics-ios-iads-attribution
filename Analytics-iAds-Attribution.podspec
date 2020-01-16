#
# Run `pod lib lint Analytics-iAds-Attribution.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'Analytics-iAds-Attribution'
  s.version          = '3.0.0'
  s.summary          = 'Measure iAds attribution data with analytics-ios.'

  s.description      = <<-DESC
Analytics-iAds-Attribution requests iAd attribution information and sends a track event with this information.
                       DESC

  s.homepage         = 'https://github.com/segmentio/analytics-ios-iads-attribution'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'f2prateek' => 'f2prateek@gmail.com' }
  s.source           = { :git => 'https://github.com/segmentio/analytics-ios-iads-attribution.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/SegmentEng'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Analytics-iAds-Attribution/Classes/**/*'

  s.dependency 'Analytics', '~> 3.7.0'
end
