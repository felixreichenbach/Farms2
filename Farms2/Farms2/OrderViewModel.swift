//
//  viewModel.swift
//  Farms2
//
//  Created by Felix Reichenbach on 26.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift

class OrderViewModel: ObservableObject {
    @EnvironmentObject var settings: AppState
    @Published var refresh = true
    
    var notificationToken: NotificationToken? = nil
    
    init() {
        
    }
    
    
    deinit {
        notificationToken?.invalidate()
    }
    
    
    func addOrder(text: String) {
        let newOrder = Order()
        newOrder.name = text
        print("addOrder")
    }
    
    func removeOrder(offsets: IndexSet) {
        print("removeOrder")
    }
    
    
    func cleanModels() {
        // Stub
    }
}
