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
      ContentView(store: Store(initialState: .init(), reducer: ContentFeature()))
    }
  }
}
