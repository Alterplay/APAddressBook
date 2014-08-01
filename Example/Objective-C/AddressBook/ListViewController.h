//
//  ListViewController.h
//  AddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTableViewController.h"

@class APAddressBook;

@interface ListViewController : DTTableViewController
{
    APAddressBook *addressBook;
}

@end
