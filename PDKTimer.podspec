#
#  Be sure to run `pod spec lint PDKTimer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "PDKTimer"
  s.version      = "0.0.1"
  s.summary      = "A simple swift GCD based Timer"

  s.description  = <<-DESC
                    A simple swift GCD based Timer
                    NSTimer is an Objective-C class that needs a @selector to call. As in swift, we don't have selectors, whe have to pass a String with the name of the function we want to be called
                    Wouldn't it be nice if whe could pass a closure to the timer?
                   DESC

  s.homepage     = "https://github.com/Produkt/PDKTimer"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Daniel García" => "dani@produktstudio.com" }
  s.social_media_url   = "http://twitter.com/fillito"

  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/Produkt/PDKTimer.git", :tag => "0.0.1" }
  s.source_files  = "PDKTimer/*"

end
