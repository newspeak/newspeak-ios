// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NPDevice.h instead.

#import <CoreData/CoreData.h>


extern const struct NPDeviceAttributes {
    __unsafe_unretained NSString *deviceToken;
    __unsafe_unretained NSString *username;
} NPDeviceAttributes;

extern const struct NPDeviceRelationships {
} NPDeviceRelationships;

extern const struct NPDeviceFetchedProperties {
} NPDeviceFetchedProperties;





@interface NPDeviceID : NSManagedObjectID {}
@end

@interface _NPDevice : NSManagedObject {}
+ (id)                   insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)           entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (NPDeviceID *)         objectID;





@property (nonatomic, strong) NSString *deviceToken;



//- (BOOL)validateDeviceToken:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString *username;



//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;






@end

@interface _NPDevice (CoreDataGeneratedAccessors)

@end

@interface _NPDevice (CoreDataGeneratedPrimitiveAccessors)


- (NSString *)primitiveDeviceToken;
- (void)      setPrimitiveDeviceToken:(NSString *)value;




- (NSString *)primitiveUsername;
- (void)      setPrimitiveUsername:(NSString *)value;




@end
