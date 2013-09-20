//
//  NPAPIClient.m
//  Newspeak
//
//  Copyright (C) 2013 Jahn Bertsch.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3 of the License.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "TestFlight.h"
#import "SVProgressHUD.h"
#import "NPAPIClient.h"
#import "NPCoreDataSingleton.h"

@interface NPAPIClient ()
@end

@implementation NPAPIClient

+ (NPAPIClient *)sharedClient
{
    static NPAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:NPAPIBaseURLString]];
    });

    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];

    if (!self) {
        return nil;
    }

    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];

    [[NSNotificationCenter defaultCenter] addObserverForName:AFIncrementalStoreContextWillFetchRemoteValues object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        DLog(@"will fetch remote values.");
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:AFIncrementalStoreContextDidFetchRemoteValues object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        DLog(@"did fetch remote values.");
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:AFIncrementalStoreContextWillSaveRemoteValues object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        DLog(@"will save remote values.");
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:AFIncrementalStoreContextDidSaveRemoteValues object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        DLog(@"did save remote values.");
    }];

    return self;
}

- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID inManagedObjectContext:(NSManagedObjectContext *)context
{
    return [[[objectID entity] name] isEqualToString:@"Token"];
}

- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship forObjectWithID:(NSManagedObjectID *)objectID inManagedObjectContext:(NSManagedObjectContext *)context
{
    DLog(@"shouldFetchRemoteValuesForRelationship %@", [[objectID entity] name]);
    return [[[objectID entity] name] isEqualToString:@"Token"];
}

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity fromResponse:(NSHTTPURLResponse *)response
{
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];

    if ([entity.name isEqualToString:@"Token"]) {
        [self handleAccessTokenResponse:representation mutablePropertyValues:mutablePropertyValues];
    } else if ([entity.name isEqualToString:@"Device"]) {
        [self handleDeviceRegistrationResponse:representation mutablePropertyValues:mutablePropertyValues];
    } else {
        DLog(@"entity name=%@", entity.name);
    }

    return mutablePropertyValues;
}

- (void)handleAccessTokenResponse:(NSDictionary *)representation mutablePropertyValues:(NSMutableDictionary *)mutablePropertyValues
{
    NSString *accessToken = [representation valueForKey:@"AccessToken"];

    [mutablePropertyValues setValue:accessToken forKey:@"accessToken"];

    DLog(@"accesstoken=%@", accessToken);
    self.accessToken = accessToken;

    // set authentication header on subsequent http requests
    [self setDefaultHeader:@"Authentication" value:self.accessToken];

    // register for push notifications
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Connected", @"in status message")];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Device Registration", @"in status message")];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    [TestFlight passCheckpoint:@"got access token"];
}

- (void)handleDeviceRegistrationResponse:(NSDictionary *)representation mutablePropertyValues:(NSMutableDictionary *)mutablePropertyValues
{
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Device Registered", @"in status message")];
    DLog(@"device registration response: %@", representation);

    [TestFlight passCheckpoint:@"device registered"];
}

- (void)handleMessageSendResponse:(NSDictionary *)representation mutablePropertyValues:(NSMutableDictionary *)mutablePropertyValues
{
    DLog(@"message send response: %@", representation);

    // display last 20 characters of response
    NSString *responseString = representation[@"Response"];
    NSString *alertMessage = [responseString substringFromIndex:([responseString length] - 18)];
    DLog(@"alertMessage=%@", alertMessage);
    [[[UIAlertView alloc] initWithTitle:@"Nachricht versendet" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

    [TestFlight passCheckpoint:@"send message successfull"];
}

@end
