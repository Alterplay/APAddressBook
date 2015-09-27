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

class ViewController: UIViewController, DTTableViewManageable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!

    let addressBook = APAddressBook()

    // MARK: - life cycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.addressBook.fieldsMask = [APContactField.Default, APContactField.Thumbnail]
        self.addressBook.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true),
                                            NSSortDescriptor(key: "lastName", ascending: true)]
        self.addressBook.filterBlock = {
            (contact: APContact) -> Bool in
            if let phones = contact.phones {
                return phones.count > 0
            }
            return false
        }
        self.addressBook.startObserveChangesWithCallback({
            [unowned self] in
            self.loadContacts()
        })
    }

    // MARK: - appearance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager.startManagingWithDelegate(self)
        self.manager.registerCellClass(TableViewCell)
        self.loadContacts()
    }

    // MARK: - actions

    @IBAction func reloadButtonPressed(sender: AnyObject) {
        self.loadContacts()
    }

    // MARK: - private

    func loadContacts() {
        self.activity.startAnimating();
        self.addressBook.loadContacts({
            (contacts: [APContact]?, error: NSError?) in
            self.activity.stopAnimating()
            self.manager.memoryStorage.removeAllTableItems();
            if let unwrappedContacts = contacts {
                self.manager.memoryStorage.addItems(unwrappedContacts)
            } else if let unwrappedError = error {
                let alert = UIAlertView(title: "Error", message: unwrappedError.localizedDescription,
                    delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        })
    }
}