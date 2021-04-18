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
    
    var body: some View {
        ZStack {
            Color("Color")
                .ignoresSafeArea()
            VStack {
                Image("Farms1024")
                    .resizable()
                    .scaledToFit()
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
                Text("\(state.errorMessage)")
                        .foregroundColor(.red)
            }
            .padding()
        }
    }
    
    
    func login(){
        state.login(email: email, password: password)
    }

    func signup(){
        state.signup(email: email, password: password)
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AppState())
    }
}
