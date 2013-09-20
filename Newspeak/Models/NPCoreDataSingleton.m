//
//  NPCoreDataSingleton.m
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

// Based on http://nachbaur.com/blog/smarter-core-data,
// https://gist.github.com/NachoMan/922496 and
// https://gist.github.com/rojotek/2362546

#import "NPCoreDataSingleton.h"

NSString *const NPCoreDataSingletonDidSaveNotification = @"NPCoreDataSingletonDidSaveNotification";
NSString *const NPCoreDataSingletonDidSaveFailedNotification = @"NPCoreDataSingletonDidSaveFailedNotification";

@interface NPCoreDataSingleton ()
@property (nonatomic, retain) NSString *applicationDatabaseDirectory;
@end

@implementation NPCoreDataSingleton

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize useInMemoryStore = _useInMemoryStore;

static dispatch_once_t dispatchOncePredicate = 0;
static NPCoreDataSingleton *sharedInstance = nil;
static NSString *sharedDatabasePath = nil;

+ (NPCoreDataSingleton *)sharedInstance
{
    dispatch_once(&dispatchOncePredicate, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
            sharedInstance.useInMemoryStore = NO;
            sharedInstance.useCustomStore = NO;
            sharedDatabasePath = nil;
        }
    });
    return sharedInstance;
}

- (void)dealloc
{
    [self saveContext];
}

- (BOOL)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;

    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"NPCoreDataSingleton: Error while saving managed object context: %@\n%@", [error localizedDescription], [error userInfo]);
            [[NSNotificationCenter defaultCenter] postNotificationName:NPCoreDataSingletonDidSaveFailedNotification
                                                                object:error];
            return NO;
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:NPCoreDataSingletonDidSaveNotification
                                                        object:nil];
    return YES;
}

- (void)reset
{
    [[NSFileManager defaultManager] removeItemAtPath:[self sqliteDefaultStoreURL].path error:NULL];
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    _managedObjectContext = nil;
    _useCustomStore = NO;
    _useInMemoryStore = NO;
    dispatchOncePredicate = 0; // resets the dispatchOncePredicate so dispatch_once will run again
    sharedInstance = nil;
}

#pragma mark - Core Data stack

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }

    NSArray *bundles = [NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]];
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:bundles];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    if (self.useCustomStore) {
        return _persistentStoreCoordinator;
    } else if (self.useInMemoryStore) {
        NSError *error = nil;
        NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                                                       configuration:nil
                                                                                                 URL:nil
                                                                                             options:nil
                                                                                               error:&error];

        if (!persistentStore) {
            NSLog(@"NPCoreDataSingleton fatal error: %@\n%@\nExiting.", [error localizedDescription], [error userInfo]);
            abort();
        }
    } else {
        [self addDefaultSQLiteStoreTo:_persistentStoreCoordinator];
    }

    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    if (![NSThread isMainThread]) {
        // Call self on main thread
        [self performSelectorOnMainThread:@selector(managedObjectContext)
                               withObject:nil
                            waitUntilDone:YES];
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;

    if (coordinator != nil) {
        #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        #else
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        #endif
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }

    return _managedObjectContext;
}

- (void)addDefaultSQLiteStoreTo:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    NSURL *storeURL = [self sqliteDefaultStoreURL];

    // Core Data version migration options
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];

    NSError *error = nil;

    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeURL
                                                        options:options
                                                          error:&error]) {
        NSLog(@"NPCoreDataSingleton fatal error: %@\n%@\nExiting.", [error localizedDescription], [error userInfo]);
        NSLog(@"storeURL=%@", storeURL);
        abort();
    }
}

#pragma mark - Private Helper Methods

// Returns the default filename for the persistent store
// In case of sqlite, this is a file with suffix .sqlite
- (NSURL *)sqliteDefaultStoreURL
{
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSString *storeFilename = [[[currentBundle infoDictionary] objectForKey:@"CFBundleExecutable"] stringByAppendingString:@".sqlite"];
    NSString *storePath = [[self applicationDatabaseDirectory] stringByAppendingPathComponent:storeFilename];

    return [NSURL fileURLWithPath:storePath];
}

// Returns a path to the application's <Library>/Database directory.
- (NSString *)applicationDatabaseDirectory
{
    if (sharedDatabasePath) {
        return sharedDatabasePath;
    }

    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    sharedDatabasePath = [libraryPath stringByAppendingPathComponent:@"Database"];

    // Ensure the database directory exists
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    BOOL isDirectory;

    if (![defaultFileManager fileExistsAtPath:sharedDatabasePath isDirectory:&isDirectory] || !isDirectory) {
        NSError *error = nil;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                               forKey:NSFileProtectionKey];
        [defaultFileManager createDirectoryAtPath:sharedDatabasePath
                      withIntermediateDirectories:YES
                                       attributes:attributes
                                            error:&error];

        if (error) {
            NSLog(@"NPCoreDataSingleton: Error creating directory path: %@\n%@", [error localizedDescription], [error userInfo]);
        }
    }

    return sharedDatabasePath;
}

@end