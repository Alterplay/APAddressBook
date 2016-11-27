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

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) APAddressBook *addressBook;
@property (nonatomic, strong) NSArray *contacts;
@end

@implementation ListViewController

#pragma mark - life cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.addressBook = [[APAddressBook alloc] init];
        __weak typeof(self) weakSelf = self;
        [self.addressBook startObserveChangesWithCallback:^
        {
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
    NSString *cellIdentifier = NSStringFromClass(ContactTableViewCell.class);
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:NSBundle.mainBundle];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    [self loadContacts];
}

#pragma mark - actions

- (IBAction)reloadPressed:(id)sender
{
    [self loadContacts];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass(ContactTableViewCell.class);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                            forIndexPath:indexPath];
    if ([cell isKindOfClass:ContactTableViewCell.class])
    {
        ContactTableViewCell *contactCell = (ContactTableViewCell *)cell;
        [contactCell updateWithContact:self.contacts[(NSUInteger)indexPath.row]];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.f;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private

- (void)loadContacts
{
    self.contacts = nil;
    [self.activity startAnimating];
    __weak __typeof(self) weakSelf = self;
    self.addressBook.fieldsMask = APContactFieldAll;
    self.addressBook.sortDescriptors = @[
     [NSSortDescriptor sortDescriptorWithKey:@"name.firstName" ascending:YES],
     [NSSortDescriptor sortDescriptorWithKey:@"name.lastName" ascending:YES]];
    self.addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };
    [self.addressBook loadContacts:^(NSArray<APContact *> *contacts, NSError *error) {
        [weakSelf.activity stopAnimating];
        if (contacts)
        {
            weakSelf.contacts = contacts;
            [weakSelf.tableView reloadData];
        }
        else if (error)
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
