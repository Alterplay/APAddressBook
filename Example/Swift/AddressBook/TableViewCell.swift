//
//  TableViewCell.swift
//  AddressBook
//
//  Created by Alexey Belkevich on 7/31/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

import Foundation

class TableViewCell: DTTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateWithModel(model: AnyObject!) {
        let contact = model as! APContact
        self.imageView?.image = contact.thumbnail
        self.textLabel?.text = self.contactName(contact)
        self.detailTextLabel?.text = self.contactPhones(contact)
    }
    
    func contactName(contact :APContact) -> String {
        if contact.firstName != nil && contact.lastName != nil {
            return "\(contact.firstName) \(contact.lastName)"
        }
        else if contact.firstName != nil || contact.lastName != nil {
            return (contact.firstName != nil) ? "\(contact.firstName)" : "\(contact.lastName)"
        }
        else {
            return "Unnamed contact"
        }
    }
    
    func contactPhones(contact :APContact) -> String {
        if let phones = contact.phones {
            let array = phones as NSArray
            return array.componentsJoinedByString(" ")
        }
        return "No phone"
    }
}