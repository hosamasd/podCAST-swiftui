//
//  podCASTApp.swift
//  podCAST
//
//  Created by hosam on 2/13/21.
//

import SwiftUI

@main
struct podCASTApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}
