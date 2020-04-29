//
//  UserSettings.swift
//  Farms2
//
//  Created by Felix Reichenbach on 28.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import Foundation
import RealmSwift

class UserSettings: ObservableObject {
    @Published var loggedIn = false
    
    @Published var errorLabel = ""
    
    init() {
        if (SyncUser.current == nil) {
            self.loggedIn = false
        } else {
            self.loggedIn = true
        }
    }
    
    func login(username: String, password: String, register: Bool) {
        print("login / signup")
        let credentials = SyncCredentials.usernamePassword(username: username, password: password, register: register);
        SyncUser.logIn(with: credentials, server: Constants.AUTH_URL) { user, error in
            if let user = user {
                Realm.Configuration.defaultConfiguration = user.configuration()
                self.errorLabel = ""
                self.loggedIn = true
            } else if let error = error {
                // handle error
                self.errorLabel = "Error: \(error)"
                print("Error: \(self.errorLabel)")
            }
        }
        return
    }
    
    func logout() {
        SyncUser.current?.logOut()
        self.loggedIn = false
        print("logout")
    }
}
