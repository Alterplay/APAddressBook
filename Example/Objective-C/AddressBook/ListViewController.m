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
        __weak typeof(self) weakSelf = self;
        [addressBook startObserveChangesWithCallback:^{
            [weakSelf loadContacts];
        }];
    }
    return self;
}

#pragma mark - appearance

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    [self registerCellClass:ContactTableViewCell.class forModelClass:APContact.class];
    [self loadContacts];
}

#pragma mark - actions

- (IBAction)reloadPressed:(id)sender
{
    [self loadContacts];
}

#pragma mark - table view data source implementation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.f;
}

#pragma mark - table view delegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private

- (void)loadContacts
{
    [self.memoryStorage removeAllTableItems];
    [self.activity startAnimating];
    __weak __typeof(self) weakSelf = self;
    addressBook.fieldsMask = APContactFieldAll;
    addressBook.sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]];
    addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };
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
