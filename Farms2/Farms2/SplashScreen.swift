//
//  SplashScreen.swift
//  Farms2
//
//  Created by Felix Reichenbach on 12.06.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.white
            .edgesIgnoringSafeArea(.all)
            Image("RealmLogo")
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
