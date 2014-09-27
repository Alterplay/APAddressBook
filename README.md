<img src="https://dl.dropboxusercontent.com/u/2334198/APAddressBook-git-teaser.png">

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
* APContactFieldPhonesWithLabels - *contact phones with labels*
* APContactFieldCompositeName - *the concatenated value of prefix, suffix, organization, first name, and last name*
* APContactFieldAddresses - *array of user addresses*
* APContactFieldRecordID - *ID of record in iOS address book*
* APContactFieldSocialProfiles - *array of social profiles*
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

**Version 0.1.4**
* Changed the definition of APAddressBookAccess to use NS_ENUM so that Swift knows how to convert APAddressBookAccess for bridging.

Thanks to [ndmeiri](https://github.com/ndmeiri) for pull request

**Version 0.1.3**
* Added the Core as a dependency of Swift subspec

Thanks to [nicopuri](https://github.com/nicopuri) for pull request


**Version 0.1.2**
* Added contact social profile

Thanks to [David Muzi](https://github.com/davidmuzi) for pull request

**Version 0.1.1**
* Added `Swift` podspec with bridging header
* Added example application in [Swift](https://developer.apple.com/swift/)
* Added contact's middle name

Thanks to [Rubén González](https://github.com/rbngzlv) for pull request

**Version 0.1.0**
* Refactored address book external changes observing

**Version 0.0.10**
* Fixed intermittent crashing in requestAccessWithCompletion handler

Thanks to [Daniel Ericsson](https://github.com/monowerker) for pull request.

**Version 0.0.9**
* Added observing of address book external changes

Made by [Serg Krivoblotsky](https://github.com/Krivoblotsky)

**Version 0.0.8**
* Added contact record creation date
* Added contact record modification date

Thanks to [Natasha Murashev](https://github.com/NatashaTheRobot) for pull request.

**Version 0.0.7**
* Added contact's concatenated name

Thanks to [Peter Robinett](https://github.com/pr1001) for pull request.

* Added contact's addresses
* Added contact's ID in iOS AddressBook

Thanks to [Cory Alder](https://github.com/coryalder) for pull request.

**Version 0.0.6**
* Added loading contacts on custom dispatch queue

Thanks to [Marcin Krzyzanowski](https://github.com/krzak) for pull request.

**Version 0.0.5**
* Fixed bad access of phone label parsing.
* Fixed memory leak of peoples array.

Thanks to [dong-seta](https://github.com/dong-seta) for found bug.

**Version 0.0.4**
* Added retrieving phone labels.

Thanks to [John Hobbs](https://github.com/jmhobbs) for pull request.

**Version 0.0.3**
* Added loading contact thumbnail.

Thanks to [Carlos Fonseca](https://github.com/carlosefonseca) for pull request.

**Version 0.0.2**
* Fixed potential crash on fetching contacts using non-property APAddressBook object.

Thanks to [Evgen Bakumenko](https://github.com/evgenbakumenko) for pull request.

**Version 0.0.1**
* First release.

#### Contributor's guide
Please, send your pull request to the `develop` branch. Thank you!


[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/b3f8691205854e15dcfebe3fc2ed599e "githalytics.com")](http://githalytics.com/Alterplay/APAddressBook)

#### Contacts

If you have improvements or concerns, feel free to post [an issue](https://github.com/Alterplay/APAddressBook/issues) and write details.

[Check out](https://github.com/Alterplay) all Alterplay's GitHub projects.
[Email us](mailto:hello@alterplay.com?subject=From%20GitHub%20APAddressBook) with other ideas and projects.
