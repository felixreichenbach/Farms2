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
    @objc dynamic var id: ObjectId = ObjectId.generate()
    @objc dynamic var name: String = "Default"
}
