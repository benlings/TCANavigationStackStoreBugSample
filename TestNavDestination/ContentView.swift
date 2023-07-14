//
//  ContentView.swift
//  Test Navigation Path + Destination
//
//  Created by Ben Lings on 14/07/2023.
//

import SwiftUI

struct ContentView: View {
  
  @State var path = [Int]()
  
  var body: some View {
    NavigationStack(path: $path) {
      VStack {
        NavigationLink("Nav link to 1", value: 1)
      }
      .padding()
      .navigationDestination(for: Int.self) { num in
        IntView(num: num)
      }
    }
  }
}

struct IntView: View {
  var num: Int
  
  @State var isDestVisible: Bool = false
  
  var body: some View {
    VStack {
      Text("Number \(num)")
      Button("Show 2") {
        isDestVisible = true
      }
    }
    .navigationDestination(isPresented: $isDestVisible) {
      Text("Destination 2")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
