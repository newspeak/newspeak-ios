//
// MIT license
//
// Copyright (c) 2013 Jahn Bertsch
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "Kiwi.h"
#import "NPCoreDataSingleton.h"

SPEC_BEGIN(CoreDataSingletonTest)

describe(@"CoreDataSingleton", ^{
    registerMatchers(@"CoreDataSingleton");
    __block NPCoreDataSingleton *coreDataSingleton;
    beforeAll(^{
        coreDataSingleton = [NPCoreDataSingleton sharedInstance];
        [coreDataSingleton reset];
    });

    context(@"when accessed", ^{
        it(@"should have default values set", ^{
            [[theValue(coreDataSingleton.useCustomStore) should] beNo];
            [[theValue(coreDataSingleton.useInMemoryStore) should] beNo];
        });
        it(@"should have a managed object model set", ^{
            [[theValue(coreDataSingleton.managedObjectModel) should] beNonNil];
        });
        it(@"should have a persistent store coordinator set", ^{
            [[theValue(coreDataSingleton.persistentStoreCoordinator) should] beNonNil];
        });
        it(@"should have a managed object context set", ^{
            [[theValue(coreDataSingleton.managedObjectContext) should] beNonNil];
        });
        it(@"should have one persistent store", ^{
            coreDataSingleton = [NPCoreDataSingleton sharedInstance];
            [[theValue([coreDataSingleton.persistentStoreCoordinator.persistentStores count]) should] equal:theValue(1)];
        });
        it(@"should have a sql store", ^{
            NSPersistentStore *persistentStore = [coreDataSingleton.persistentStoreCoordinator.persistentStores objectAtIndex:0];
            [[[persistentStore type] should] equal:@"SQLite"];
        });
    });

    context(@"saving context", ^{
        it(@"should be successful", ^{
            [[theValue([coreDataSingleton saveContext]) should] beYes];
        });
    });

    context(@"after reset", ^{
        it(@"should still have defaults set", ^{
            [coreDataSingleton reset];
            [[theValue(coreDataSingleton.useCustomStore) should] beNo];
            [[theValue(coreDataSingleton.useInMemoryStore) should] beNo];
        });
    });

    context(@"after reset and setting to in-memory store", ^{
        beforeAll(^{
            [coreDataSingleton reset];
            coreDataSingleton.useInMemoryStore = YES;
        });
        it(@"should have one persistent store", ^{
            [[theValue([coreDataSingleton.persistentStoreCoordinator.persistentStores count]) should] equal:theValue(1)];
        });
        it(@"should have an in-memory store", ^{
            NSPersistentStore *persistentStore = [coreDataSingleton.persistentStoreCoordinator.persistentStores objectAtIndex:0];
            [[[persistentStore type] should] equal:@"InMemory"];
        });
    });
});

SPEC_END