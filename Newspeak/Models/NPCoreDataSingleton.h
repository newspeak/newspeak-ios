//
//  NPCoreDataSingleton.h
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/** Simplify CoreData usage. */

extern NSString *const NPCoreDataSingletonDidSaveNotification;
extern NSString *const NPCoreDataSingletonDidSaveFailedNotification;

@interface NPCoreDataSingleton : NSObject

/**
   Shared managed object context of the application.

   If the context doesn't already exist, it is created and bound to the
   persistent store coordinator of the application.
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/**
   Shared managed object model of the application.

   If the model doesn't already exist, it is created from the model contained in
   the application bundle.
 */
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

/**
   Shared persistent store coordinator of the application.

   If the coordinator does not already exist, it is created and the application's
   store is added to it.
 */
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/** If true, all data is stored in RAM. Useful for unit testing. */
@property (nonatomic, assign) BOOL useInMemoryStore;

/** If true, a custom store can be added later since no default store is used. */
@property (nonatomic, assign) BOOL useCustomStore;

/** The singleton object of this class. */
+ (NPCoreDataSingleton *)sharedInstance;

/**
   Persist data.

   @return YES on success
 */
- (BOOL)                 saveContext;

/**
   Adds a SQLiteStore in the default location to the passed persistent store
   coordinator.

   Allows for use with [AFIncrementalStore](https://github.com/AFNetworking/AFIncrementalStore)
   like this:

       [NPCoreDataSingleton sharedInstance].useCustomStore = YES;
       AFIncrementalStore *incrementalStore = (AFIncrementalStore *)
           [[NPCoreDataSingleton sharedInstance].persistentStoreCoordinator
           addPersistentStoreWithType:[NPIncrementalStore type]
           configuration:nil URL:nil options:nil error:nil];
       [[NPCoreDataSingleton sharedInstance] addDefaultSQLiteStoreTo:
           incrementalStore.backingPersistentStoreCoordinator];

   @param persistentStoreCoordinator The store coordinator the default SQLite
   store is added to.
 */
- (void)                 addDefaultSQLiteStoreTo:(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

/**
   Unset current persistent store coordinator, managed object model and managed
   object context and set default values.

   On next access, a new store will be created. Useful when using in-memory store
   in unit tests to reset state between tests.
 */
- (void)                 reset;

@end
