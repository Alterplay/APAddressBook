//
//  ContactTableViewCell.m
//  AddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "APContact.h"

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
    self.textLabel.text = [self contactName:contact];
    self.detailTextLabel.text = [self contactPhones:contact];
}

#pragma mark - private

- (NSString *)contactName:(APContact *)contact
{
    if (contact.firstName && contact.lastName)
    {
        return [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    }
    else if (contact.firstName || contact.lastName)
    {
        return contact.firstName ?: contact.lastName;
    }
    else
    {
        return @"Untitled contact";
    }
}

- (NSString *)contactPhones:(APContact *)contact
{
    if (contact.phones.count > 1)
    {
        return [contact.phones componentsJoinedByString:@", "];
    }
    else
    {
        return contact.phones.firstObject ?: @"No phones";
    }
}

@end
