#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint digital_login.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'digital_login'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for Digital Login integration.'
  s.description      = <<-DESC
The Digital Login Plugin simplifies the integration of Azerbaijan's digital login system, provided by Digital Login, into your Flutter applications. With this plugin, developers can enable secure and streamlined login flows using Digital Login, allowing users to authenticate via the national digital ID system.
                       DESC
  s.homepage         = 'https://appstyle.az/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'AppStyle Team' => 'huseyntahirovv@gmail.com' }
  s.source           = { :http => 'https://github.com/htahirov/digital-login/tree/release' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  s.resource_bundles = {'digital_login_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
