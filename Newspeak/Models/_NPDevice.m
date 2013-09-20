// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NPDevice.m instead.

#import "_NPDevice.h"

const struct NPDeviceAttributes NPDeviceAttributes = {
    .deviceToken = @"deviceToken",
    .username    = @"username",
};

const struct NPDeviceRelationships NPDeviceRelationships = {
};

const struct NPDeviceFetchedProperties NPDeviceFetchedProperties = {
};

@implementation NPDeviceID
@end

@implementation _NPDevice

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Device";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Device" inManagedObjectContext:moc_];
}

- (NPDeviceID *)objectID
{
    return (NPDeviceID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];


    return keyPaths;
}

@dynamic deviceToken;






@dynamic username;











@end
