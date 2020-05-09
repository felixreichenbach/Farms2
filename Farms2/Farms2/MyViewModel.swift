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

        self.realm = try! Realm(configuration: user.configuration(partitionValue: "partition"))
        self.myOrders = realm.objects(MyOrder.self)
        self.initialize(realm: realm)
    }
    
    func initialize(realm: Realm) {
        notificationToken = realm.objects(MyOrder.self).observe{ _ in
            self.refresh.toggle()
            print("notified")
        }
    }
    
    func addModel(text: String) {
        let newOrder = MyOrder()
        newOrder.name = text
        try! self.realm.write {
            self.realm.add(newOrder)
        }
    }

    
    func cleanModels() {
        // Stub
    }
}
