//
//  TableViewCell.swift
//  AddressBook
//
//  Created by Alexey Belkevich on 7/31/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

import UIKit
import DTModelStorage

class TableViewCell: UITableViewCell, ModelTransfer {

    // MARK: - life cycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - ModelTransfer
    
    func updateWithModel(contact: APContact) {
        self.imageView?.image = contact.thumbnail
        self.textLabel?.text = self.contactName(contact)
        self.detailTextLabel?.text = self.contactPhones(contact)
    }

    // MARK: - prviate
    
    func contactName(contact :APContact) -> String {
        if let firstName = contact.firstName, lastName = contact.lastName {
            return "\(firstName) \(lastName)"
        }
        else if let firstName = contact.firstName {
            return "\(firstName)"
        }
        else if let lastName = contact.lastName {
            return "\(lastName)"
        }
        else {
            return "Unnamed contact"
        }
    }
    
    func contactPhones(contact :APContact) -> String {
        if let phones = contact.phones as NSArray? {
            return phones.componentsJoinedByString(" ")
        }
        return "No phone"
    }
}