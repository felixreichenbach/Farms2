//
//  LoginView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 28.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var settings: UserState
    
    @State var username: String = "foo@bar.com"
    @State var password: String = "password"
    
    var body: some View {
        VStack {
            Text("Welcome")
                .font(.title)
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Passwod", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)
            Button(action: {
                self.settings.login(username: self.username, password: self.password, register: false)
            }) {
                Text("Login")
            }
            .font(.headline)
            .padding(.bottom, 20)
            Button(action: {
                self.settings.login(username: self.username, password: self.password, register: true)
            }) {
                Text("Signup")
            }
            .font(.headline)
            .padding()
            Text(settings.errorLabel)
                .foregroundColor(.red)
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
