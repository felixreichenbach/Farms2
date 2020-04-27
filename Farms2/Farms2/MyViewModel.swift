//
//  viewModel.swift
//  Farms2
//
//  Created by Felix Reichenbach on 26.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import Foundation
import RealmSwift

class MyViewModel: ObservableObject, Identifiable {

    @Published var refresh = true
    
    let myModel: Results<MyModel>
    let realm: Realm
    
    var notificationToken: NotificationToken? = nil

    init() {
        // Get the default Realm
        self.realm = try! Realm()
        // Query Realm for all MyModels
        self.myModel = realm.objects(MyModel.self)
        
        // Observe Realm Notifications
        self.notificationToken = realm.observe { notification, realm in
            print("Realm notification: \(notification)")
            self.refresh.toggle()
        }
    }
    
    deinit {
        self.notificationToken?.invalidate()
        print("deinit")
    }
    
    func addModel() {
        // Persist your data easily
        try! realm.write {
            self.realm.add(MyModel())
        }
        self.refresh.toggle()
    }
    
    func cleanModels() {
        print("cleanModels function not yet implemented")
        // Deleting object ins realm files throws an error
        // Feature: https://github.com/realm/realm-cocoa/pull/6231

        /*
        try! self.realm.write {
            realm.deleteAll()
        }*/
    }
}
