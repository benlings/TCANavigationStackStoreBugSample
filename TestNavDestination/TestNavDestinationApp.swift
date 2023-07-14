//
//  TestNavDestinationApp.swift
//  TestNavDestination
//
//  Created by Ben Lings on 14/07/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct TestNavDestinationApp: App {
  var body: some Scene {
    WindowGroup {
      TabView {
        Vanilla.ContentView()
          .tabItem { Text("Vanilla") }
        VanillaStack.ContentView(store: Store(initialState: .init(), reducer: VanillaStack.ContentFeature()))
          .tabItem { Text("Vanilla Stack") }
        TCA.ContentView(store: Store(initialState: .init(), reducer: TCA.ContentFeature()))
          .tabItem { Text("TCA") }
      }
    }
  }
}
