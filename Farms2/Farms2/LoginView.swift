//
//  LoginView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 28.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI
import RealmSwift

struct LoginView: View {
    
    @EnvironmentObject var state: AppState
    
    @State var email: String = "foo@bar.com"
    @State var password: String = "password"
    
    var body: some View {
        VStack {
            Text("Welcome")
                .font(.title)
            TextField("Username", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Passwod", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)
            Button(action: {
                app?.login(credentials: Credentials.emailPassword(email: email, password: password)) { (result) in
                    switch result {
                    case .failure(let error):
                        print("Login failed: \(error.localizedDescription)")
                    case .success(let user):
                        print("Successfully logged in as user \(user)")
                        // Now logged in, do something with user
                        // Remember to dispatch to main if you are doing anything on the UI thread
                    }
                }
            }) {
                Text("Login")
            }
            .font(.headline)
            .padding(.bottom, 20)
            Button(action: {
                app?.emailPasswordAuth.registerUser(email: email, password: password) { (error) in
                    guard error == nil else {
                        print("Failed to register: \(error!.localizedDescription)")
                        return
                    }
                    // Registering just registers. You can now log in.
                    print("Successfully registered user.")
                }
            }) {
                Text("Signup")
            }
            .font(.headline)
            .padding()
            Text(state.errorLabel)
                .foregroundColor(.red)
        }
        .padding()
    }
}


/// A button that handles logout requests.
struct LogoutButton: View {
    @EnvironmentObject var state: AppState
    var body: some View {
        Button("Log Out") {
            guard let app = app else {
                print("Not using Realm Sync - not logging out")
                return
            }
            state.shouldIndicateActivity = true
            app.currentUser?.logOut().receive(on: DispatchQueue.main).sink(receiveCompletion: { _ in }, receiveValue: {
                state.shouldIndicateActivity = false
                state.logoutPublisher.send($0)
            }).store(in: &state.cancellables)
        }.disabled(state.shouldIndicateActivity)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AppState())
    }
}
