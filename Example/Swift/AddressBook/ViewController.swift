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

class ViewController: UIViewController, DTTableViewManageable
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!

    let addressBook = APAddressBook()

    // MARK: - life cycle

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        addressBook.fieldsMask = [APContactField.default, APContactField.thumbnail]
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
        addressBook.startObserveChanges
        {
            [unowned self] in
            self.loadContacts()
        }
    }

    // MARK: - appearance

    override func viewDidLoad()
    {
        super.viewDidLoad()
        manager.startManaging(withDelegate: self)
        manager.register(TableViewCell.self)
        loadContacts()
    }

    // MARK: - actions

    @IBAction func reloadButtonPressed(_ sender: AnyObject)
    {
        loadContacts()
    }

    // MARK: - private

    func loadContacts()
    {
        activity.startAnimating();
        addressBook.loadContacts
        {
            [unowned self] (contacts: [APContact]?, error: Error?) in
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
