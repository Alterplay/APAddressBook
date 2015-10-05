//
//  ContactTableViewCell.m
//  AddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "APContact.h"
#import "APPhone.h"
#import "APJob.h"
#import "APName.h"
#import "APEmail.h"

@interface ContactTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *phonesLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailsLabel;
@end

@implementation ContactTableViewCell

#pragma mark - life cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

#pragma mark - table view model transfer implementation

- (void)updateWithModel:(id)model
{
    APContact *contact = model;
    self.nameLabel.text = [self contactName:contact];
    self.companyLabel.text = contact.job.company ?: @"(No company)";
    self.phonesLabel.text = [self contactPhones:contact];
    self.emailsLabel.text = [self contactEmails:contact];
    self.photoView.image = contact.thumbnail ?: [UIImage imageNamed:@"no_photo"];
}

#pragma mark - private

- (NSString *)contactName:(APContact *)contact
{
    if (contact.name.compositeName)
    {
        return contact.name.compositeName;
    }
    else if (contact.name.firstName && contact.name.lastName)
    {
        return [NSString stringWithFormat:@"%@ %@", contact.name.firstName, contact.name.lastName];
    }
    else if (contact.name.firstName || contact.name.lastName)
    {
        return contact.name.firstName ?: contact.name.lastName;
    }
    else
    {
        return @"Untitled contact";
    }
}

- (NSString *)contactPhones:(APContact *)contact
{
    if (contact.phones.count > 0)
    {
        NSMutableString *result = [[NSMutableString alloc] init];
        for (APPhone *phone in contact.phones)
        {
            NSString *string = phone.localizedLabel.length == 0 ? phone.number :
                               [NSString stringWithFormat:@"%@ (%@)", phone.number,
                                                          phone.localizedLabel];
            [result appendFormat:@"%@, ", string];
        }
        return result;
    }
    else
    {
        return @"(No phones)";
    }
}

- (NSString *)contactEmails:(APContact *)contact
{
    if (contact.emails.count > 1)
    {
        NSMutableString *result = [[NSMutableString alloc] init];
        for (APEmail *email in contact.emails)
        {
            [result appendFormat:@"%@, ", email.address];
        }
        return result;
    }
    else
    {
        return contact.emails.count == 1 ? contact.emails[0].address : @"(No emails)";
    }
}

@end
