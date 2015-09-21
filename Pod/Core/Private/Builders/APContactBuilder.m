//
//  APContactBuilder 
//  AddressBook
//
//  Created by Alexey Belkevich on 21.09.15.
//  Copyright © 2015 alterplay. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "APContactBuilder.h"
#import "APContact.h"
#import "APAddress.h"
#import "APPhoneWithLabel.h"
#import "APSocialProfile.h"

@interface APContact ()
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *compositeName;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSArray *phones;
@property (nonatomic, strong) NSArray *phonesWithLabels;
@property (nonatomic, strong) NSArray *emails;
@property (nonatomic, strong) NSArray *addresses;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSNumber *recordID;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *modificationDate;
@property (nonatomic, strong) NSArray *socialProfiles;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSArray *linkedRecordIDs;
@end

@implementation APContactBuilder

#pragma mark - public

+ (APContact *)contactWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask
{
    APContact *contact = [[APContact alloc] init];
    if (fieldMask & APContactFieldFirstName)
    {
        contact.firstName = [self stringProperty:kABPersonFirstNameProperty fromRecord:recordRef];
    }
    if (fieldMask & APContactFieldMiddleName)
    {
        contact.middleName = [self stringProperty:kABPersonMiddleNameProperty fromRecord:recordRef];
    }
    if (fieldMask & APContactFieldLastName)
    {
        contact.lastName = [self stringProperty:kABPersonLastNameProperty fromRecord:recordRef];
    }
    if (fieldMask & APContactFieldCompositeName)
    {
        contact.compositeName = [self compositeNameFromRecord:recordRef];
    }
    if (fieldMask & APContactFieldCompany)
    {
        contact.company = [self stringProperty:kABPersonOrganizationProperty fromRecord:recordRef];
    }
    if (fieldMask & APContactFieldJobTitle)
    {
        contact.jobTitle = [self stringProperty:kABPersonJobTitleProperty fromRecord:recordRef];
    }
    if (fieldMask & APContactFieldPhones)
    {
        contact.phones = [self arrayProperty:kABPersonPhoneProperty fromRecord:recordRef];
    }
    if (fieldMask & APContactFieldPhonesWithLabels)
    {
        contact.phonesWithLabels = [self arrayOfPhonesWithLabelsFromRecord:recordRef];
    }
    if (fieldMask & APContactFieldEmails)
    {
        contact.emails = [self arrayProperty:kABPersonEmailProperty fromRecord:recordRef];
    }
    if (fieldMask & APContactFieldPhoto)
    {
        contact.photo = [self imagePropertyFullSize:YES fromRecord:recordRef];
    }
    if (fieldMask & APContactFieldThumbnail)
    {
        contact.thumbnail = [self imagePropertyFullSize:NO fromRecord:recordRef];
    }
    if (fieldMask & APContactFieldAddresses)
    {
        NSMutableArray *addresses = [[NSMutableArray alloc] init];
        NSArray *array = [self arrayProperty:kABPersonAddressProperty fromRecord:recordRef];
        for (NSDictionary *dictionary in array)
        {
            APAddress *address = [[APAddress alloc] initWithAddressDictionary:dictionary];
            [addresses addObject:address];
        }
        contact.addresses = addresses.copy;
    }
    if (fieldMask & APContactFieldRecordID)
    {
        contact.recordID = @(ABRecordGetRecordID(recordRef));
    }
    if (fieldMask & APContactFieldCreationDate)
    {
        contact.creationDate = [self dateProperty:kABPersonCreationDateProperty fromRecord:recordRef];
    }
    if (fieldMask & APContactFieldModificationDate)
    {
        contact.modificationDate = [self dateProperty:kABPersonModificationDateProperty fromRecord:recordRef];
    }
    if (fieldMask & APContactFieldSocialProfiles)
    {
        NSMutableArray *profiles = [[NSMutableArray alloc] init];
        NSArray *array = [self arrayProperty:kABPersonSocialProfileProperty fromRecord:recordRef];
        for (NSDictionary *dictionary in array)
        {
            APSocialProfile *profile = [[APSocialProfile alloc] initWithSocialDictionary:dictionary];
            [profiles addObject:profile];
        }

        contact.socialProfiles = profiles;
    }
    if (fieldMask & APContactFieldNote)
    {
        contact.note = [self stringProperty:kABPersonNoteProperty fromRecord:recordRef];
    }
    if (fieldMask & APContactFieldLinkedRecordIDs)
    {
        NSMutableOrderedSet *linkedRecordIDs = [[NSMutableOrderedSet alloc] init];

        CFArrayRef linkedPeopleRef = ABPersonCopyArrayOfAllLinkedPeople(recordRef);
        CFIndex count = CFArrayGetCount(linkedPeopleRef);
        for (CFIndex i = 0; i < count; i++)
        {
            ABRecordRef linkedRecordRef = CFArrayGetValueAtIndex(linkedPeopleRef, i);
            [linkedRecordIDs addObject:@(ABRecordGetRecordID(linkedRecordRef))];
        }
        CFRelease(linkedPeopleRef);

        // remove self from linked records
        [linkedRecordIDs removeObject:@(ABRecordGetRecordID(recordRef))];
        contact.linkedRecordIDs = linkedRecordIDs.array;
    }
    return contact;
}

#pragma mark - private

+ (NSString *)stringProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    CFTypeRef valueRef = (ABRecordCopyValue(recordRef, property));
    return (__bridge_transfer NSString *)valueRef;
}

+ (NSArray *)arrayProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self enumerateMultiValueOfProperty:property fromRecord:recordRef
                              withBlock:^(ABMultiValueRef multiValue, NSUInteger index)
                              {
                                  CFTypeRef value = ABMultiValueCopyValueAtIndex(multiValue, index);
                                  NSString *string = (__bridge_transfer NSString *)value;
                                  if (string)
                                  {
                                      [array addObject:string];
                                  }
                              }];
    return array.copy;
}


+ (NSDate *)dateProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    CFDateRef dateRef = (ABRecordCopyValue(recordRef, property));
    return (__bridge_transfer NSDate *)dateRef;
}

+ (NSArray *)arrayOfPhonesWithLabelsFromRecord:(ABRecordRef)recordRef
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self enumerateMultiValueOfProperty:kABPersonPhoneProperty fromRecord:recordRef
                              withBlock:^(ABMultiValueRef multiValue, NSUInteger index)
                              {
                                  CFTypeRef rawPhone = ABMultiValueCopyValueAtIndex(multiValue, index);
                                  NSString *phone = (__bridge_transfer NSString *)rawPhone;
                                  if (phone)
                                  {
                                      NSString *originalLabel = [self originalLabelFromMultiValue:multiValue index:index];
                                      NSString *localizedLabel = [self localizedLabelFromMultiValue:multiValue index:index];
                                      APPhoneWithLabel *phoneWithLabel = [[APPhoneWithLabel alloc] initWithPhone:phone originalLabel:originalLabel
                                                                                                  localizedLabel:localizedLabel];
                                      [array addObject:phoneWithLabel];
                                  }
                              }];
    return array.copy;
}

+ (UIImage *)imagePropertyFullSize:(BOOL)isFullSize fromRecord:(ABRecordRef)recordRef
{
    ABPersonImageFormat format = isFullSize ? kABPersonImageFormatOriginalSize :
                                 kABPersonImageFormatThumbnail;
    NSData *data = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(recordRef, format);
    return [UIImage imageWithData:data scale:UIScreen.mainScreen.scale];
}

+ (NSString *)originalLabelFromMultiValue:(ABMultiValueRef)multiValue index:(NSUInteger)index
{
    NSString *label;
    CFTypeRef rawLabel = ABMultiValueCopyLabelAtIndex(multiValue, index);
    label = (__bridge_transfer NSString *)rawLabel;
    return label;
}

+ (NSString *)localizedLabelFromMultiValue:(ABMultiValueRef)multiValue index:(NSUInteger)index
{
    NSString *label;
    CFTypeRef rawLabel = ABMultiValueCopyLabelAtIndex(multiValue, index);
    if (rawLabel)
    {
        CFStringRef localizedLabel = ABAddressBookCopyLocalizedLabel(rawLabel);
        if (localizedLabel)
        {
            label = (__bridge_transfer NSString *)localizedLabel;
        }
        CFRelease(rawLabel);
    }
    return label;
}

+ (NSString *)compositeNameFromRecord:(ABRecordRef)recordRef
{
    CFStringRef compositeNameRef = ABRecordCopyCompositeName(recordRef);
    return (__bridge_transfer NSString *)compositeNameRef;
}

+ (void)enumerateMultiValueOfProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
                            withBlock:(void (^)(ABMultiValueRef multiValue, NSUInteger index))block
{
    ABMultiValueRef multiValue = ABRecordCopyValue(recordRef, property);
    if (multiValue)
    {
        NSUInteger count = (NSUInteger)ABMultiValueGetCount(multiValue);
        for (NSUInteger i = 0; i < count; i++)
        {
            block(multiValue, i);
        }
        CFRelease(multiValue);
    }
}

@end