<img src="https://dl.dropboxusercontent.com/u/2334198/APAddressBook-git-teaser.png">

APAddressBook is a wrapper on [AddressBook.framework](https://developer.apple.com/library/ios/documentation/AddressBook/Reference/AddressBook_iPhoneOS_Framework/_index.html) that gives easy access to native address book without pain in a head.

#### Features
* Load contacts from iOS address book asynchronously
* Decide what contact data fields you need to load (for example, only first name and phone number)
* Filter contacts to get only necessary records (for example, you need only contacts with email)
* Sort contacts with array of any [NSSortDescriptor](https://developer.apple.com/library/mac/documentation/cocoa/reference/foundation/classes/NSSortDescriptor_Class/Reference/Reference.html)

#### Installation
Add `APAddressBook` pod to Podfile

#### Using

###### Load contacts
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

### Note
> Callback block will be run in main thread!

###### Select contact fields bit-mask
Available fields:
* APContactFieldFirstName - *contact first name*
* APContactFieldLastName - *contact last name*
* APContactFieldCompany - *contact company (organisation)*
* APContactFieldPhones - *contact phones array*
* APContactFieldEmails - *contact emails array*
* APContactFieldPhoto - *contact photo*
* APContactFieldThumbnail - *contact thumbnail*
* APContactFieldDefault - *contact first name, last name and phones array*
* APContactFieldAll - *all contact fields described above*

### Note
> You should use `APContactFieldPhoto` very carefully, because it takes a lot of memory and may crash the application. Using `APContactFieldThumbnail` is much safer.

Example of loading contact with first name and photo:
```objective-c
APAddressBook *addressBook = [[APAddressBook alloc] init];
addressBook.fieldsMask = APContactFieldFirstName | APContactFieldPhoto;
```

###### Filter contacts
The most common use of this option is to filter contacts without phone number. Example:
```objective-c
addressBook.filterBlock = ^BOOL(APContact *contact)
{
    return contact.phones.count > 0;
};
```

###### Sort contacts
APAddressBook returns unsorted contacts. So, most of users would like to sort contacts by first name and last name.
```objective-c
addressBook.sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]
];
```

###### Check address book access
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

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/b3f8691205854e15dcfebe3fc2ed599e "githalytics.com")](http://githalytics.com/Alterplay/APAddressBook)
If you have improvements or concerns, feel free to post [an issue](https://github.com/Alterplay/APAddressBook/issues) and write details.

#### Contacts

[Check out](https://github.com/Alterplay) all Alterplay's GitHub projects.
[Email us](mailto:hello@alterplay.com?subject=From%20GitHub%20APAddressBook) with other ideas and projects.

#### Versions

**Version 0.0.3**
* Added loading contact thumbnail. Thanks to [Carlos Fonseca](https://github.com/carlosefonseca).

**Version 0.0.2**
* Fixed potential crash on fetching contacts using non-property APAddressBook object. Thanks to [Evgen Bakumenko](https://github.com/evgenbakumenko).

**Version 0.0.1**
* First release.
