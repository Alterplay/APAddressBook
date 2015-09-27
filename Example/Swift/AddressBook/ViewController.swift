//
//  ViewController.swift
//  AddressBook
//
//  Created by Alexey Belkevich on 7/31/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

import UIKit

class ViewController: DTTableViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!

    let addressBook = APAddressBook()

    // MARK: - life cycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.addressBook.fieldsMask = [APContactField.Default, APContactField.Thumbnail]
        self.addressBook.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true),
                                            NSSortDescriptor(key: "lastName", ascending: true)]
        self.addressBook.filterBlock = {
            (contact: APContact!) -> Bool in
            return contact.phones.count > 0
        }
        self.addressBook.startObserveChangesWithCallback({
            [unowned self] in
            self.loadContacts()
        })
    }

    // MARK: - appearance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCellClass(TableViewCell.self, forModelClass: APContact.self)
        self.loadContacts()
    }

    // MARK: - actions

    @IBAction func reloadButtonPressed(sender: AnyObject) {
        self.loadContacts()
    }

    // MARK: - private

    func loadContacts() {
        self.activity.startAnimating();
        self.memoryStorage().removeAllTableItems();
        self.addressBook.loadContacts({
            (contacts: [AnyObject]!, error: NSError!) in
            self.activity.stopAnimating()
            if (contacts != nil) {
                self.memoryStorage().addItems(contacts)
            } else if (error != nil) {
                let alert = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil,
                        cancelButtonTitle: "OK")
                alert.show()
            }
        })
    }
}