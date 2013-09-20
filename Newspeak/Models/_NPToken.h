// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NPToken.h instead.

#import <CoreData/CoreData.h>


extern const struct NPTokenAttributes {
    __unsafe_unretained NSString *accessToken;
    __unsafe_unretained NSString *password;
    __unsafe_unretained NSString *username;
} NPTokenAttributes;

extern const struct NPTokenRelationships {
} NPTokenRelationships;

extern const struct NPTokenFetchedProperties {
} NPTokenFetchedProperties;






@interface NPTokenID : NSManagedObjectID {}
@end

@interface _NPToken : NSManagedObject {}
+ (id)                   insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)           entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (NPTokenID *)          objectID;





@property (nonatomic, strong) NSString *accessToken;



//- (BOOL)validateAccessToken:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString *password;



//- (BOOL)validatePassword:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString *username;



//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;






@end

@interface _NPToken (CoreDataGeneratedAccessors)

@end

@interface _NPToken (CoreDataGeneratedPrimitiveAccessors)


- (NSString *)primitiveAccessToken;
- (void)      setPrimitiveAccessToken:(NSString *)value;




- (NSString *)primitivePassword;
- (void)      setPrimitivePassword:(NSString *)value;




- (NSString *)primitiveUsername;
- (void)      setPrimitiveUsername:(NSString *)value;




@end
