//
//  UserSettings.swift
//  Farms2
//
//  Created by Felix Reichenbach on 28.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import Foundation
import RealmSwift

let app = RealmApp(Constants.MY_REALM_APP,
                   configuration: AppConfiguration(baseURL: Constants.MY_INSTANCE_BASE_URL,
                                transport: nil,
                                localAppName: nil,
                                localAppVersion: nil))

class ContentState: ObservableObject {
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
        app.login(withCredential: AppCredentials.anonymous()) { (_, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
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
