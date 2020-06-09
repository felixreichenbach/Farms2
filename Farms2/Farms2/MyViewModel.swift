//
//  viewModel.swift
//  Farms2
//
//  Created by Felix Reichenbach on 26.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift

class MyViewModel: ObservableObject {
    @EnvironmentObject var settings: AppState
    @Published var refresh = true
    
    let myOrders: Results<MyOrder>
    let realm: Realm
    
    private var notificationToken: NotificationToken? = nil

    init() {
        guard let user = app.currentUser() else {
            fatalError("Must be logged in to access this view")
        }

        self.realm = try! Realm(configuration: user.configuration(partitionValue: (app.currentUser()?.identity)! as String))
        self.myOrders = realm.objects(MyOrder.self)
        self.notificationToken =
            realm.objects(MyOrder.self).observe{[weak self] (changes: RealmCollectionChange) in
                self!.refresh.toggle()
            print("notified: \(changes)")
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    
    func addOrder(text: String) {
        let newOrder = MyOrder()
        newOrder.name = text
        newOrder._partition = (app.currentUser()?.identity!)! as String
        try! self.realm.write(withoutNotifying: [notificationToken!]) {
            self.realm.add(newOrder)
        }
    }
    
    func removeOrder(offsets: IndexSet) {
        
        let delOrder = myOrders[offsets.first!]

        // Delete an object with a transaction
        try! realm.write {
            realm.delete(delOrder)
        }
    }

    
    func cleanModels() {
        // Stub
    }
}
