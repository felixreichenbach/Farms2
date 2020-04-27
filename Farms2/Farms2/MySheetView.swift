//
//  MySheetView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct MySheetView: View {
    
    @Binding var showSheetView: Bool
    @ObservedObject var viewModel: MySheetViewModel
    @State private var inputText: String = ""
    
    init(showSheetView: Binding<Bool>) {
        self.viewModel = MySheetViewModel()
        self._showSheetView = showSheetView
    }
    
    private var validated: Bool {
        inputText.isEmpty
    }
    
    var body: some View {
        VStack {
            Text("Add New Model")
                .font(.headline)
            TextField("Enter Text", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                self.viewModel.addModel(text: self.inputText)
                self.showSheetView.toggle()
            }) {
                Text("Save")
                    .font(.headline)
            }.disabled(validated)
        }
    }
}

struct MySheetView_Previews: PreviewProvider {
    static var previews: some View {
        MySheetView(showSheetView: .constant(true))
    }
}
