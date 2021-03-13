//
//  MyModel.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import Foundation
import RealmSwift


/// An individual order. Part of a `Collection`.
final class Order: Object, ObjectKeyIdentifiable {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var name: String = "Default"
    
    /// The backlink to the `Group` this order is a part of.
    let collection = LinkingObjects(fromType: Collection.self, property: "orders")
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}


/// Represents a collection of orders.
final class Collection: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Collection.
    @objc dynamic var _id = ObjectId.generate()
    /// The collection of orders in this group.
    let orders = RealmSwift.List<Order>()
    /// Declares the _id member as the primary key to the realm.
    override class func primaryKey() -> String? {
        "_id"
    }
}
