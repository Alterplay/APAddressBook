//
//  ViewController.swift
//  AddressBook
//
//  Created by Alexey Belkevich on 7/31/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

import UIKit
import DTTableViewManager
import DTModelStorage
import APAddressBook

class ViewController: UIViewController, DTTableViewManageable
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!

    let addressBook = APAddressBook()

    // MARK: - life cycle

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        addressBook.fieldsMask = [APContactField.Default, APContactField.Thumbnail]
        addressBook.sortDescriptors = [NSSortDescriptor(key: "name.firstName", ascending: true),
                                       NSSortDescriptor(key: "name.lastName", ascending: true)]
        addressBook.filterBlock =
        {
            (contact: APContact) -> Bool in
            if let phones = contact.phones
            {
                return phones.count > 0
            }
            return false
        }
        addressBook.startObserveChangesWithCallback
        {
            [unowned self] in
            self.loadContacts()
        }
    }

    // MARK: - appearance

    override func viewDidLoad()
    {
        super.viewDidLoad()
        manager.startManagingWithDelegate(self)
        manager.registerCellClass(TableViewCell)
        loadContacts()
    }

    // MARK: - actions

    @IBAction func reloadButtonPressed(sender: AnyObject)
    {
        loadContacts()
    }

    // MARK: - private

    func loadContacts()
    {
        activity.startAnimating();
        addressBook.loadContacts
        {
            [unowned self] (contacts: [APContact]?, error: NSError?) in
            self.activity.stopAnimating()
            self.manager.memoryStorage.removeAllItems();
            if let contacts = contacts
            {
                self.manager.memoryStorage.addItems(contacts)
            }
            else if let error = error
            {
                let alert = UIAlertView(title: "Error", message: error.localizedDescription,
                                        delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
    }
}