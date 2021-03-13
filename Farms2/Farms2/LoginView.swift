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
    
    @State var email: String = "demo@realm.com"
    @State var password: String = "password"
    @State var error: Error?
    
    var body: some View {
        VStack {
            Text("Welcome")
                .font(.title)
            TextField("Username", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Passwod", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)
            Button("Login", action: login)
                .font(.headline)
                .padding(.bottom, 20)
            Button("Signup", action: signup)
                .font(.headline)
                .padding()
            if let error = error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    
    func login(){
        state.shouldIndicateActivity = true
        app?.login(credentials: Credentials.emailPassword(email: email, password: password))
            .receive(on: DispatchQueue.main).sink(
                receiveCompletion: {
                    state.shouldIndicateActivity = false
                    switch ($0) {
                    case .finished:
                        print("Successfully logged in as user")
                        // Now logged in, do something with user
                        // Remember to dispatch to main if you are doing anything on the UI thread
                        break
                    case .failure(let error):
                        print("Login failed: \(error.localizedDescription)")
                    }
                },
                receiveValue: {
                    self.error = nil
                    state.loginPublisher.send($0)
                }
            )
            .store(in: &state.cancellables)
    }

    func signup(){
        app?.emailPasswordAuth.registerUser(email: email, password: password) { (error) in
            guard error == nil else {
                self.error = error
                return
            }
            // Registering just registers. You can now log in.
            print("Successfully registered user.")
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AppState())
    }
}
