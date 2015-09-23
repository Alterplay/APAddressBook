//
//  APContactBuilder 
//  AddressBook
//
//  Created by Alexey Belkevich on 21.09.15.
//  Copyright © 2015 alterplay. All rights reserved.
//

#import "APContactBuilder.h"
#import "APContactDataExtractor.h"
#import "APContact.h"

@interface APContactBuilder ()
@property (nonatomic, strong) APContactDataExtractor *extractor;
@end

@implementation APContactBuilder

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    self.extractor = [[APContactDataExtractor alloc] init];
    return self;
}

#pragma mark - public

- (APContact *)contactWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask
{
    self.extractor.recordRef = recordRef;
    APContact *contact = [[APContact alloc] init];
    if (fieldMask & APContactFieldFirstName)
    {
        contact.firstName = [self.extractor stringProperty:kABPersonFirstNameProperty];
    }
    if (fieldMask & APContactFieldMiddleName)
    {
        contact.middleName = [self.extractor stringProperty:kABPersonMiddleNameProperty];
    }
    if (fieldMask & APContactFieldLastName)
    {
        contact.lastName = [self.extractor stringProperty:kABPersonLastNameProperty];
    }
    if (fieldMask & APContactFieldCompositeName)
    {
        contact.compositeName = [self.extractor compositeName];
    }
    if (fieldMask & APContactFieldCompany)
    {
        contact.company = [self.extractor stringProperty:kABPersonOrganizationProperty];
    }
    if (fieldMask & APContactFieldJobTitle)
    {
        contact.jobTitle = [self.extractor stringProperty:kABPersonJobTitleProperty];
    }
    if (fieldMask & APContactFieldPhones)
    {
        contact.phones = [self.extractor arrayProperty:kABPersonPhoneProperty];
    }
    if (fieldMask & APContactFieldPhonesWithLabels)
    {
        contact.phonesWithLabels = [self.extractor phonesWithLabels];
    }
    if (fieldMask & APContactFieldEmails)
    {
        contact.emails = [self.extractor arrayProperty:kABPersonEmailProperty];
    }
    if (fieldMask & APContactFieldEmailsWithLabels)
    {
        contact.emailsWithLabels = [self.extractor emailsWithLabels];
    }
    if (fieldMask & APContactFieldPhoto)
    {
        contact.photo = [self.extractor imagePropertyFullSize:YES];
    }
    if (fieldMask & APContactFieldThumbnail)
    {
        contact.thumbnail = [self.extractor imagePropertyFullSize:NO];
    }
    if (fieldMask & APContactFieldAddresses)
    {
        contact.addresses = [self.extractor addresses];
    }
    if (fieldMask & APContactFieldRecordID)
    {
        contact.recordID = @(ABRecordGetRecordID(recordRef));
    }
    if (fieldMask & APContactFieldCreationDate)
    {
        contact.creationDate = [self.extractor dateProperty:kABPersonCreationDateProperty];
    }
    if (fieldMask & APContactFieldModificationDate)
    {
        contact.modificationDate = [self.extractor dateProperty:kABPersonModificationDateProperty];
    }
    if (fieldMask & APContactFieldSocialProfiles)
    {
        contact.socialProfiles = [self.extractor socialProfiles];
    }
    if (fieldMask & APContactFieldNote)
    {
        contact.note = [self.extractor stringProperty:kABPersonNoteProperty];
    }
    if (fieldMask & APContactFieldLinkedRecordIDs)
    {
        contact.linkedRecordIDs = [self.extractor linkedRecordIDs];
    }
    if (fieldMask & APContactFieldWebsites)
    {
        contact.websites = [self.extractor arrayProperty:kABPersonURLProperty];
    }
    if (fieldMask & APContactFieldBirthday)
    {
        contact.birthday = [self.extractor dateProperty:kABPersonBirthdayProperty];
    }
    if (fieldMask & APContactFieldSource)
    {
        contact.source = [self.extractor source];
    }
    if (fieldMask & APContactFieldRelatedPersons)
    {
        contact.relatedPersons = [self.extractor relatedPersons];
    }
    return contact;
}

@end