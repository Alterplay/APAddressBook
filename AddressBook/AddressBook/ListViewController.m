//
//  ListViewController.m
//  AddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "ListViewController.h"
#import "ContactTableViewCell.h"
#import "APContact.h"
#import "APAddressBook.h"
#import "ContactViewController.h"

@interface ListViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end

@implementation ListViewController

#pragma mark - life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        addressBook = [[APAddressBook alloc] init];
    }
    return self;
}

#pragma mark - appearance

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerCellClass:ContactTableViewCell.class forModelClass:APContact.class];
    [self loadContacts];
}

#pragma mark - table view delegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:NSStringFromClass(ContactViewController.class) sender:self];
}

#pragma mark - private

- (void)loadContacts
{
    [self.activity startAnimating];
    __weak __typeof(self) weakSelf = self;
    [addressBook loadContacts:^(NSArray *contacts, NSError *error)
    {
        [weakSelf.activity stopAnimating];
        if (!error)
        {
            [weakSelf.memoryStorage addTableItems:contacts];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

@end
