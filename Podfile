# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!
# ignore all warnings from all pods
inhibit_all_warnings!

target 'Tastii' do
	pod 'HockeySDK'
	pod 'FBSDKCoreKit', '~> 4.8'
	pod 'FBSDKLoginKit', '~> 4.8'
	pod 'FBSDKShareKit', '~> 4.8'
    pod 'Koloda'
	pod 'TagListView'
	pod 'Alamofire'
	pod 'SwiftyJSON'
	pod 'MBProgressHUD'
	pod 'AlamofireImage'
end

post_install do |installer|
    `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end

target 'TastiiTests' do

end

target 'TastiiUITests' do

end

