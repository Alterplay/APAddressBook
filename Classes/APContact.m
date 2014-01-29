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
            NSArray *phonesWithLabels = [self arrayProperty:kABPersonPhoneProperty fromRecord:recordRef withLabel:YES];
            NSMutableArray *phones = [[NSMutableArray alloc] init];
            NSMutableArray *labels = [[NSMutableArray alloc] init];
            for(NSArray *entry in phonesWithLabels) {
                [phones addObject:entry[0]];
                [labels addObject:entry[1]];
            }
            _phones = [[NSArray alloc] initWithArray:phones];
            _phoneLabels = [[NSArray alloc] initWithArray:labels];
        }
        if (fieldMask & APContactFieldEmails)
        {
            _emails = [self arrayProperty:kABPersonEmailProperty fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldPhoto)
        {
            _photo = [self imagePropertyFullSize:YES fromRecord:recordRef];
        }
        if (fieldMask & APContactFieldThumbnail)
        {
            _thumbnail = [self imagePropertyFullSize:NO fromRecord:recordRef];
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

- (NSArray *)arrayProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef withLabel:(BOOL)withLabel {
    ABMultiValueRef multiValue = ABRecordCopyValue(recordRef, property);
    NSUInteger count = (NSUInteger)ABMultiValueGetCount(multiValue);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < count; i++)
    {
        CFTypeRef value = ABMultiValueCopyValueAtIndex(multiValue, i);
        NSString *string = (__bridge_transfer NSString *)value;
        if (string)
        {
            if(withLabel) {
                CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(multiValue, i);
                NSString *label = (__bridge_transfer NSString *) ABAddressBookCopyLocalizedLabel(locLabel);
                [array addObject:[[NSArray alloc] initWithObjects:string, label, nil]];
            }
            else {
                [array addObject:string];
            }
        }
    }
    CFRelease(multiValue);
    return array.copy;
}


- (NSArray *)arrayProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    return [self arrayProperty:property fromRecord:recordRef withLabel:NO];
}

- (UIImage *)imagePropertyFullSize:(BOOL)isFullSize fromRecord:(ABRecordRef)recordRef
{
    ABPersonImageFormat format = isFullSize ? kABPersonImageFormatOriginalSize :
                                 kABPersonImageFormatThumbnail;
    NSData *data = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(recordRef, format);
    return [UIImage imageWithData:data scale:UIScreen.mainScreen.scale];
}

@end
