//
//  UserSettings.swift
//  Farms2
//
//  Created by Felix Reichenbach on 28.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

// Global application object
let app = Constants.USE_REALM_SYNC ? App(id: Constants.MY_REALM_APP) : nil


class AppState: ObservableObject {
    
    /// Publisher that monitors log in state.
    var loginPublisher = PassthroughSubject<User, Error>()
    /// Publisher that monitors log out state.
    var logoutPublisher = PassthroughSubject<Void, Error>()
    /// Cancellables to be retained for any Future.
    var cancellables = Set<AnyCancellable>()
    /// Whether or not the app is active in the background.
    @Published var shouldIndicateActivity = false
    /// The list of items in the first group in the realm that will be displayed to the user.
    @Published var orders: RealmSwift.List<Order>?
    
    // My OLD CODE
    @Published var loggedIn = false
    @Published var errorLabel = ""
    @Published var showSplash = false
    
    init() {
        
        // Create a private subject for the opened realm, so that:
        // - if we are not using Realm Sync, we can open the realm immediately.
        // - if we are using Realm Sync, we can open the realm later after login.
        let realmPublisher = PassthroughSubject<Realm, Error>()
        // Specify what to do when the realm opens, regardless of whether
        // we're authenticated and using Realm Sync or not.
        realmPublisher
            .sink(receiveCompletion: { result in
                // Check for failure.
                if case let .failure(error) = result {
                    print("Failed to log in and open realm: \(error.localizedDescription)")
                }
            }, receiveValue: { realm in
                // The realm has successfully opened.
                // If no group has been created for this app, create one.
                if realm.objects(Collection.self).count == 0 {
                    try! realm.write {
                        realm.add(Collection())
                    }
                }
                assert(realm.objects(Collection.self).count > 0)
                self.orders = realm.objects(Collection.self).first!.orders
            })
            .store(in: &cancellables)
    }
}
