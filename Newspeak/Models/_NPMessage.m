// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NPMessage.m instead.

#import "_NPMessage.h"

const struct NPMessageAttributes NPMessageAttributes = {
    .id        = @"id",
    .message   = @"message",
    .recipient = @"recipient",
};

const struct NPMessageRelationships NPMessageRelationships = {
};

const struct NPMessageFetchedProperties NPMessageFetchedProperties = {
};

@implementation NPMessageID
@end

@implementation _NPMessage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Message";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Message" inManagedObjectContext:moc_];
}

- (NPMessageID *)objectID
{
    return (NPMessageID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    if ([key isEqualToString:@"idValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"id"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }

    return keyPaths;
}

@dynamic id;



- (int64_t)idValue
{
    NSNumber *result = [self id];

    return [result longLongValue];
}

- (void)setIdValue:(int64_t)value_
{
    [self setId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveIdValue
{
    NSNumber *result = [self primitiveId];

    return [result longLongValue];
}

- (void)setPrimitiveIdValue:(int64_t)value_
{
    [self setPrimitiveId:[NSNumber numberWithLongLong:value_]];
}

@dynamic message;






@dynamic recipient;











@end
