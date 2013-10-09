platform :ios, '5.0'

inhibit_all_warnings!

pod 'AFNetworking', "1.3.3"
pod 'AFIncrementalStore', :head
pod 'AFDownloadRequestOperation'
pod 'SVProgressHUD', :head
pod 'ViewDeck'
pod 'InAppSettingsKit'
pod 'Reachability', :head
pod 'Appirater'
pod 'CBIntrospect', :head
pod 'TestFlightSDK', "2.0"

target :UnitTests, exclusive: true do
   pod 'Specta', git: 'https://github.com/mgrimes/specta.git',
                 branch: 'xctest_integration'
   pod 'Expecta', git: 'https://github.com/twobitlabs/expecta.git',
                  branch: 'xcode-5'
end

target 'IntegrationTests' do
  pod 'Specta', git: 'https://github.com/mgrimes/specta.git',
                branch: 'xctest_integration'
  pod 'KIF', :head
end
