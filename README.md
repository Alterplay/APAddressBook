<img src="https://dl.dropboxusercontent.com/u/2334198/APAddressBook-git-teaser.png">
[![Build Status](https://api.travis-ci.org/Alterplay/APAddressBook.svg)](https://travis-ci.org/Alterplay/APAddressBook)

APAddressBook is a wrapper on [AddressBook.framework](https://developer.apple.com/library/ios/documentation/AddressBook/Reference/AddressBook_iPhoneOS_Framework/_index.html) that gives easy access to native address book without pain in a head.

#### Features
* Load contacts from iOS address book asynchronously
* Decide what contact data fields you need to load (for example, only first name and phone number)
* Filter contacts to get only necessary records (for example, you need only contacts with email)
* Sort contacts with array of any [NSSortDescriptor](https://developer.apple.com/library/mac/documentation/cocoa/reference/foundation/classes/NSSortDescriptor_Class/Reference/Reference.html)

#### Objective-c
**Installation**

Add `APAddressBook` pod to [Podfile](http://guides.cocoapods.org/syntax/podfile.html)
```ruby
pod 'APAddressBook'
```

**Load contacts**
```objective-c
APAddressBook *addressBook = [[APAddressBook alloc] init];
// don't forget to show some activity
[addressBook loadContacts:^(NSArray *contacts, NSError *error)
{
    // hide activity
    if (!error)
    {
        // do something with contacts array
    }
    else
    {
        // show error
    }
}];
```

> Callback block will be run on main queue! If you need to run callback block on custom queue use `loadContactsOnQueue:completion:` method

**Select contact fields bit-mask**

Available fields:
* APContactFieldFirstName - *contact first name*
* APContactFieldMiddleName - *contact middle name*
* APContactFieldLastName - *contact last name*
* APContactFieldCompany - *contact company (organization)*
* APContactFieldPhones - *contact phones array*
* APContactFieldEmails - *contact emails array*
* APContactFieldPhoto - *contact photo*
* APContactFieldThumbnail - *contact thumbnail*
* APContactFieldCreationDate - *contact creation date*
* APContactFieldModificationDate - *contact modification date*
* APContactFieldPhonesWithLabels - *contact phones with original and localized labels*
* APContactFieldCompositeName - *the concatenated value of prefix, suffix, organization, first name, and last name*
* APContactFieldAddresses - *array of user addresses*
* APContactFieldRecordID - *ID of record in iOS address book*
* APContactFieldSocialProfiles - *array of social profiles*
* APContactFieldNote - *contact notes*
* APContactFieldLinkedRecordIDs - *linked contacts record IDs*
* APContactFieldJobTitle - *contact job title*
* APContactFieldDefault - *contact first name, last name and phones array*
* APContactFieldAll - *all contact fields described above*

> You should use `APContactFieldPhoto` very carefully, because it takes a lot of memory and may crash the application. Using `APContactFieldThumbnail` is much safer.

Example of loading contact with first name and photo:
```objective-c
APAddressBook *addressBook = [[APAddressBook alloc] init];
addressBook.fieldsMask = APContactFieldFirstName | APContactFieldPhoto;
```

**Filter contacts**

The most common use of this option is to filter contacts without phone number. Example:
```objective-c
addressBook.filterBlock = ^BOOL(APContact *contact)
{
    return contact.phones.count > 0;
};
```

**Sort contacts**

APAddressBook returns unsorted contacts. So, most of users would like to sort contacts by first name and last name.
```objective-c
addressBook.sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]
];
```

**Get contact by address book record ID**
```objective-c
APContact *contact = [addressBook getContactByRecordID:recordID];
```

**Check address book access**
```objective-c
switch([APAddressBook access])
{
    case APAddressBookAccessUnknown:
        // Application didn't request address book access yet
        break;

    case APAddressBookAccessGranted:
        // Access granted
        break;

    case APAddressBookAccessDenied:
        // Access denied or restricted by privacy settings
        break;
}
```

**Observe address book external changes**
```objective-c
// start observing
[addressBook startObserveChangesWithCallback:^
{
    NSLog(@"Address book changed!");
}];
// stop observing
[addressBook stopObserveChanges];
```

#### Swift
**Installation**
```ruby
pod 'APAddressBook/Swift'
```
Import `APAddressBook-Bridging.h` to application's objective-c bridging file.
```objective-c
#import "APAddressBook-Bridging.h"
```

**Example**

See exmaple application in `Example/Swift` directory.
```Swift
self.addressBook.loadContacts(
    { (contacts: [AnyObject]!, error: NSError!) in
        if contacts {
            // do something with contacts
        }
        else if error {
            // show error
        }
    })
```

#### History

[Releases](https://github.com/Alterplay/APAddressBook/releases)

#### Contributor guide

[Contributor Guide](https://github.com/Alterplay/APAddressBook/wiki/Contributor-Guide)

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/b3f8691205854e15dcfebe3fc2ed599e "githalytics.com")](http://githalytics.com/Alterplay/APAddressBook)

#### Contacts

If you have improvements or concerns, feel free to post [an issue](https://github.com/Alterplay/APAddressBook/issues) and write details.

[Check out](https://github.com/Alterplay) all Alterplay's GitHub projects.
[Email us](mailto:hello@alterplay.com?subject=From%20GitHub%20APAddressBook) with other ideas and projects.
