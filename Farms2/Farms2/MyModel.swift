//
//  MyModel.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import Foundation
import RealmSwift

class MyModel: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name: String = "Default"
}
