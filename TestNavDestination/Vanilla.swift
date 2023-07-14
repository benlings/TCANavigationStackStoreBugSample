//
//  ContentView.swift
//  Test Navigation Path + Destination
//
//  Created by Ben Lings on 14/07/2023.
//

import SwiftUI

enum Vanilla {
  class ContentModel: ObservableObject {
    @Published var path = [Int]()
  }

  struct ContentView: View {

    @ObservedObject var model = ContentModel()

    var body: some View {
      NavigationStack(path: $model.path) {
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

  class IntModel: ObservableObject {
    @Published var isDestVisible: Bool = false
  }


  struct IntView: View {
    let num: Int

    @ObservedObject var model = IntModel()

    var body: some View {
      VStack {
        Text("Number \(num)")
        Button("Show 2") {
          model.isDestVisible = true
        }
      }
      .navigationDestination(isPresented: $model.isDestVisible) {
        Text("Destination 2")
      }
    }
  }
}

struct VanillaContentView_Previews: PreviewProvider {
  static var previews: some View {
    Vanilla.ContentView()
  }
}

