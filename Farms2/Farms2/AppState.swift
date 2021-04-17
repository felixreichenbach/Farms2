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
    /// Error message
    @Published var errorMessage: String = ""
    
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
        
        
        // If the Realm app is nil, we are in the local-only use case
        // and do not need to log in or configure the realm for Sync.
        guard let app = app else {
            // MARK: Local-Only Use Case
            print("Not using Realm Sync - opening realm")
            // Directly open the default local-only realm.
            realmPublisher.send(try! Realm())
            return
        }
        // Monitor login state and open a realm on login.
        loginPublisher
            .receive(on: DispatchQueue.main) // Ensure we update UI elements on the main thread.
            .flatMap { user -> RealmPublishers.AsyncOpenPublisher in
                // Logged in, now open the realm.
                // We want to chain the login to the opening of the realm.
                // flatMap() takes a result and returns a different Publisher.
                // In this case, flatMap() takes the user result from the login
                // and returns the realm asyncOpen's result publisher for further
                // processing.
                // We use "SharedPartition" as the partition value so that all users of this app
                // can see the same data. If we used the user.id, we could store data per user.
                // However, with anonymous authentication, that user.id changes upon logout and login,
                // so we will not see the same data or be able to sync across devices.
                
                let configuration = user.configuration(partitionValue: user.id)
                
                // Loading may take a moment, so indicate activity.
                self.shouldIndicateActivity = true
                // Open the realm and return its publisher to continue the chain.
                return Realm.asyncOpen(configuration: configuration)
            }
            .receive(on: DispatchQueue.main) // Ensure we update UI elements on the main thread.
            .map { // For each realm result, whether successful or not, always stop indicating activity.
                self.shouldIndicateActivity = false // Stop indicating activity.
                return $0 // Forward the result as-is to the next stage.
            }
            .subscribe(realmPublisher) // Forward the opened realm to the handler we set up earlier.
            .store(in: &self.cancellables)
        
        // Monitor logout state and unset the items list on logout.
        logoutPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in
                    print("received")
                },
                receiveValue: { _ in
                    self.orders = nil
                })
            .store(in: &self.cancellables)
        
        // If we already have a current user from a previous app
        // session, announce it to the world.
        if let user = app.currentUser {
            loginPublisher.send(user)
        }
    }
    
    
    func login(email:String, password:String){
        print("AppState: login")
        shouldIndicateActivity = true
        app?.login(credentials: Credentials.emailPassword(email: email, password: password))
            .receive(on: DispatchQueue.main).sink(
                receiveCompletion: {
                    self.shouldIndicateActivity = false
                    switch ($0) {
                    case .finished:
                        print("Successfully logged in as user")
                        // Now logged in, do something with user
                        // Remember to dispatch to main if you are doing anything on the UI thread
                        break
                    case .failure(let error):
                        self.errorMessage = "Login failed: \(error.localizedDescription)"
                        print("Login failed: \(error.localizedDescription)")
                    }
                },
                receiveValue: {
                    self.errorMessage = ""
                    self.loginPublisher.send($0)
                }
            )
            .store(in: &self.cancellables)
    }
    

    func signup(email:String, password:String) {
        print("AppState: signup")
        shouldIndicateActivity = true
        app?.emailPasswordAuth.registerUser(email: email, password: password, completion: { [weak self](error) in
            // Completion handlers are not necessarily called on the UI thread.
            // This call to DispatchQueue.main.async ensures that any changes to the UI,
            // namely disabling the loading indicator and navigating to the next page,
            // are handled on the UI thread:
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Signup failed: \(error!)")
                    self?.errorMessage = "Signup failed: \(error!.localizedDescription)"
                    self?.shouldIndicateActivity = false
                    return
                }
                print("Signup successful!")
                // Registering just registers. Now we need to sign in, but we can reuse the existing email and password.
                self?.errorMessage = ""
                self?.shouldIndicateActivity = false
                self?.login(email: email, password: password)
            }
        })
    }
    
    func logout(){
        print("AppState: logout")
        shouldIndicateActivity = true
        app?.currentUser?.logOut().receive(on: DispatchQueue.main).sink(receiveCompletion: { _ in }, receiveValue: {
            self.shouldIndicateActivity = false
            self.logoutPublisher.send($0)
        }).store(in: &cancellables)
    }
    
    func addOrder(text: String) {
        print("AppState: addOrder")
        
        let newOrder = Order()
        newOrder.name = text
        
        try! orders?.realm!.write {
            orders?.append(newOrder)
        }
    }
    
    func delete(at offsets: IndexSet) {
        print("AppState: delete")
        guard let realm = orders?.realm else {
            orders!.remove(at: offsets.first!)
            return
        }
        try! realm.write {
            realm.delete(orders![offsets.first!])
        }
    }
}
