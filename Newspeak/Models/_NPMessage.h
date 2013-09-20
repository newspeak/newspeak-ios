// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NPMessage.h instead.

#import <CoreData/CoreData.h>


extern const struct NPMessageAttributes {
    __unsafe_unretained NSString *id;
    __unsafe_unretained NSString *message;
    __unsafe_unretained NSString *recipient;
} NPMessageAttributes;

extern const struct NPMessageRelationships {
} NPMessageRelationships;

extern const struct NPMessageFetchedProperties {
} NPMessageFetchedProperties;






@interface NPMessageID : NSManagedObjectID {}
@end

@interface _NPMessage : NSManagedObject {}
+ (id)                   insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)           entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (NPMessageID *)        objectID;





@property (nonatomic, strong) NSNumber *id;



@property int64_t idValue;
- (int64_t)              idValue;
- (void)                 setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString *message;



//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString *recipient;



//- (BOOL)validateRecipient:(id*)value_ error:(NSError**)error_;






@end

@interface _NPMessage (CoreDataGeneratedAccessors)

@end

@interface _NPMessage (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber *)primitiveId;
- (void)      setPrimitiveId:(NSNumber *)value;

- (int64_t)   primitiveIdValue;
- (void)      setPrimitiveIdValue:(int64_t)value_;




- (NSString *)primitiveMessage;
- (void)      setPrimitiveMessage:(NSString *)value;




- (NSString *)primitiveRecipient;
- (void)      setPrimitiveRecipient:(NSString *)value;




@end
