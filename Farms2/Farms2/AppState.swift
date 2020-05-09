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

class AppState: ObservableObject {
    @Published var loggedIn = false
    @Published var errorLabel = ""
    
    init() {
        if (app.currentUser() == nil) {
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
            DispatchQueue.main.async {
                self.loggedIn = true
            }
        }
        return
    }
    
    func logout() {
        app.logOut { (error) in
                guard error == nil else {
                    fatalError(error!.localizedDescription)
                }
            }
        self.loggedIn = false
        print("logout")
    }
}
