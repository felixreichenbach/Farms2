//
//  MySheetView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI
import RealmSwift

struct AddOrderView: View {

    @EnvironmentObject var state: AppState
    @Binding var showAddSheetView: Bool
    
    @State private var inputText: String = ""
    
    private var validated: Bool {
        inputText.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add New Order")
                    .font(.headline)
                TextField("Enter Text", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    state.addOrder(text: inputText)
                    self.showAddSheetView.toggle()
                }) {
                    Text("Save")
                        .font(.headline)
                }.disabled(validated)
            }
            .navigationBarTitle(Text("New Order Form"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showAddSheetView.toggle()
                }) {
                    Text("Done").bold()
                })
        }
    }
}


struct AddOrderView_Previews: PreviewProvider {
    static var previews: some View {
        AddOrderView(showAddSheetView: .constant(true))
    }
}

