//
//  HomescreenView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 22.05.21.
//  Copyright © 2021 Felix Reichenbach. All rights reserved.
//

import SwiftUI
import RealmSwift

struct UserProfile: View {
    
    @EnvironmentObject var state: AppState
    
    @State private var username: String = ""
    @State private var firstname : String
    @State private var lastname : String
    
    init() {
        firstname = "\(app?.currentUser?.customData["firstname"]??.stringValue ?? "")"
        lastname = "\(app?.currentUser?.customData["lastname"]??.stringValue ?? "")"
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                TextField("Firstname",
                          text: $firstname)
                TextField("Lastname",
                          text: $lastname)
            }
            .navigationBarTitle(Text("User Profile"))
            .navigationBarItems(
                leading:
                    Button("Logout", action: logout))
        }
        
    }
    
    func logout(){
        print("logout")
        state.logout()
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
