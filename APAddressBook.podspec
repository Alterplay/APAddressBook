Pod::Spec.new do |s|
  s.name         = "APAddressBook"
  s.version      = "0.1.8"
  s.summary      = "Easy access to iOS address book"
  s.homepage     = "https://github.com/Alterplay/APAddressBook"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Alexey Belkevich" => "belkevich.alexey@gmail.com" }
  s.source       = { :git => "https://github.com/Alterplay/APAddressBook.git",
		                 :tag => s.version.to_s }
  s.requires_arc = true
  s.frameworks   = 'AddressBook'

  s.social_media_url      = "https://twitter.com/alterplay"
  s.screenshot            = "https://dl.dropboxusercontent.com/u/2334198/APAddressBook-git-teaser.png"
  s.ios.deployment_target = "5.0"

  s.subspec 'Core' do |sp|
    sp.source_files = 'Pod/Core/*.{h,m}'
  end

  s.subspec 'Swift' do |sp|
    sp.source_files = 'Pod/Swift/*.h'
    sp.dependency 'APAddressBook/Core'
  end

  s.default_subspecs = 'Core'
end
