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
        if let firstName = contact.name?.firstName, lastName = contact.name?.lastName {
            return "\(firstName) \(lastName)"
        }
        else if let firstName = contact.name?.firstName {
            return "\(firstName)"
        }
        else if let lastName = contact.name?.lastName {
            return "\(lastName)"
        }
        else {
            return "Unnamed contact"
        }
    }

    func contactPhones(contact :APContact) -> String {
        if let phones = contact.phones {
            var phonesString = ""
            for phone in phones {
                if let number = phone.number {
                    phonesString = phonesString + " " + number
                }
            }
            return phonesString
        }
        return "No phone"
    }
}