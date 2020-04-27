//
//  MySheetViewModel.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import Foundation
import RealmSwift

class MySheetViewModel: ObservableObject {
    
    let realm: Realm
    
    init() {
        try! realm = Realm()
    }
    
    func addModel(text: String) {
        let newModel = MyModel()
        newModel.name = text
        // Persist your data easily
        try! realm.write {
            self.realm.add(newModel)
        }
    }
}
