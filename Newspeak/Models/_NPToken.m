// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NPToken.m instead.

#import "_NPToken.h"

const struct NPTokenAttributes NPTokenAttributes = {
    .accessToken = @"accessToken",
    .password    = @"password",
    .username    = @"username",
};

const struct NPTokenRelationships NPTokenRelationships = {
};

const struct NPTokenFetchedProperties NPTokenFetchedProperties = {
};

@implementation NPTokenID
@end

@implementation _NPToken

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Token" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Token";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Token" inManagedObjectContext:moc_];
}

- (NPTokenID *)objectID
{
    return (NPTokenID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];


    return keyPaths;
}

@dynamic accessToken;






@dynamic password;






@dynamic username;











@end
