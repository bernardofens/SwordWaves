//
//  POC_2DGameApp.swift
//  POC-2DGame
//

import SwiftUI

@main
struct POC_2DGameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            GameView()
                .ignoresSafeArea()
        }
    }
}
