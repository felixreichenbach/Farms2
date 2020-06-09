//
//  MyModel.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import Foundation
import RealmSwift

class MyOrder: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var name: String = "Default"
    
    // Not sure if _partition is needed
    @objc dynamic var _partition: String = "Default"
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
