//
//  Order.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import Foundation
import RealmSwift

// This is the Realm data model, represented as a collection and schema in MongoDB Atlas
class Order: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var name: String = ""
    @objc dynamic var details: String? = nil
    dynamic var lineItem: LineItem? = nil
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}

class LineItem: Object {
    @objc dynamic var name = ""
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
