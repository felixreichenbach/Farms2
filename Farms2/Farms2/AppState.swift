//
//  UserSettings.swift
//  Farms2
//
//  Created by Felix Reichenbach on 28.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import Foundation
import RealmSwift

let app = App(id: Constants.MY_REALM_APP,
              configuration: AppConfiguration(baseURL: Constants.MY_INSTANCE_BASE_URL,
                                              transport: nil,
                                              localAppName: nil,
                                              localAppVersion: nil))

class AppState: ObservableObject {
    @Published var loggedIn = false
    @Published var errorLabel = ""
    @Published var showSplash = false
    
    init() {
        if (app.currentUser == nil) {
            self.loggedIn = false
        } else {
            self.loggedIn = true
        }
    }
    
    
    func signup(username: String, password: String) {
        print("signup")
        let emailPassProvider = app.emailPasswordAuth
        emailPassProvider.registerUser(email: username, password: password){ (result) in
            self.login(username: username, password: password)
        }
    }
    
    func login(username: String, password: String) {
        print("login")
        DispatchQueue.main.async {
            self.showSplash = true
        }
        let credentials = Credentials.emailPassword(email: username, password: password)
        app.login(credentials: credentials) { (result) in
            switch result {
            case .success(let username):
                print("user: \(username)")
                DispatchQueue.main.async {
                    self.loggedIn = true
                    self.errorLabel = ""
                    self.showSplash = false
                    return
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showSplash = false
                    self.errorLabel = error.localizedDescription
                }
            }
        }
    }
    
    func logout() {
        let group = DispatchGroup() // initialize
        
        group.enter() // wait
        app.currentUser?.logOut() { (error: Error?) in
            guard error == nil else {
                fatalError("Error: \(error!.localizedDescription)")
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.loggedIn = false
            print("logout")
        }
    }
}
