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
    
    var notificationToken: NotificationToken? = nil
    
    init() {
        guard let user = app.currentUser else {
            fatalError("Must be logged in to access this view")
        }
        
        self.realm = try! Realm(configuration: user.configuration(partitionValue: (app.currentUser?.id)! as String))
        self.myOrders = realm.objects(MyOrder.self)
        
        // Observe collection notifications. Keep a strong
        // reference to the notification token or the
        // observation will stop.
        self.notificationToken = self.myOrders.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.refresh.toggle()
                print("notified: \(changes)")
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self?.refresh.toggle()
                print("notified: \(changes)")
                // Always apply updates in the following order: deletions, insertions, then modifications.
                // Handling insertions before deletions may result in unexpected behavior.
                /*
                 tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                 with: .automatic)
                 tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                 with: .automatic)
                 tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                 with: .automatic)
                 tableView.endUpdates()
                 */
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    
    deinit {
        notificationToken?.invalidate()
    }
    
    
    func addOrder(text: String) {
        let newOrder = MyOrder()
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
