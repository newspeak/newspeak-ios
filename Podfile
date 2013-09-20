platform :ios, '5.0'

inhibit_all_warnings!

pod 'AFNetworking', "1.3.2"
pod 'AFIncrementalStore', :head
pod 'AFDownloadRequestOperation'
pod 'SVProgressHUD', :head
pod 'ViewDeck'
pod 'InAppSettingsKit'
pod 'Reachability', :head
pod 'Appirater'
pod 'CBIntrospect', :head
pod 'TestFlightSDK', "2.0"

# add kiwi as an exclusive dependency for the UnitTests target
# Currently based on https://github.com/modocache/KiwiFutureProofingSamples
target :UnitTests, exclusive: true do
   pod 'Kiwi/XCTest', git: 'https://github.com/modocache/Kiwi.git',
                      commit: '343a1ee0f6'
end

# add kif for the IntegrationTests target
target 'IntegrationTests' do
  pod 'Specta', :head
  pod 'KIF', '~> 2.0'
end
