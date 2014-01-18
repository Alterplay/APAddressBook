//
//  APContact.m
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APContact.h"

@implementation APContact

#pragma mark - life cycle

- (id)initWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask
{
    self = [super init];
    if (self)
    {
        _fieldMask = fieldMask;
        if (fieldMask & APContactFieldFirstName)
        {
            _firstName = [self stringProperty:kABPersonFirstNameProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldLastName)
        {
            _lastName = [self stringProperty:kABPersonLastNameProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldCompany)
        {
            _company = [self stringProperty:kABPersonOrganizationProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldPhones)
        {
            _phones = [self arrayProperty:kABPersonPhoneProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldEmails)
        {
            _emails = [self arrayProperty:kABPersonEmailProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldPhoto)
        {
            NSData *imageData = (__bridge_transfer NSData *)ABPersonCopyImageData(recordRef);
            _photo = [UIImage imageWithData:imageData scale:UIScreen.mainScreen.scale];
        }
        if (fieldMask & APContactFieldPhotoThumb)
        {
            NSData *imageData = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(recordRef, kABPersonImageFormatThumbnail);
            _photoThumb = [UIImage imageWithData:imageData scale:UIScreen.mainScreen.scale];
        }
    }
    return self;
}

#pragma mark - private

- (NSString *)stringProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    CFTypeRef valueRef = (ABRecordCopyValue(recordRef, property));
    return (__bridge_transfer NSString *)valueRef;
}

- (NSArray *)arrayProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    ABMultiValueRef multiValue = ABRecordCopyValue(recordRef, property);
    NSUInteger count = (NSUInteger)ABMultiValueGetCount(multiValue);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < count; i++)
    {
        CFTypeRef value = ABMultiValueCopyValueAtIndex(multiValue, i);
        NSString *string = (__bridge_transfer NSString *)value;
        if (string)
        {
            [array addObject:string];
        }
    }
    CFRelease(multiValue);
    return array.copy;
}
@end
