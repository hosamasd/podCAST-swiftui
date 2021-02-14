//
//  podCASTApp.swift
//  podCAST
//
//  Created by hosam on 2/13/21.
//

import SwiftUI

@main
struct podCASTApp: App {
    let vv = MainViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .environmentObject(vv)
        }
    }
}
