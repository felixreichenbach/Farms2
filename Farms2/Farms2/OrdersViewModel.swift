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

class OrdersViewModel: ObservableObject {
    @EnvironmentObject var settings: AppState
    @Published var refresh = true
    
    let myOrders: Results<Order>
    let realm: Realm
    
    private var notificationToken: NotificationToken? = nil

    init() {
        guard let user = app.currentUser() else {
            fatalError("Must be logged in to access this view")
        }
        // Open realm with logged in user and user id as partition value
        self.realm = try! Realm(configuration: user.configuration(partitionValue: (app.currentUser()?.identity)! as String))
        self.myOrders = realm.objects(Order.self)
        self.notificationToken =
            realm.objects(Order.self).observe{[weak self] (changes: RealmCollectionChange) in
                self!.refresh.toggle()
            print("notified: \(changes)")
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    
    func addOrder(text: String) {
        let newOrder = Order()
        newOrder.name = text
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
