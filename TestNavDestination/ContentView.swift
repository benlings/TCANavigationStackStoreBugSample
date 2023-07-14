//
//  ContentView.swift
//  Test Navigation Path + Destination
//
//  Created by Ben Lings on 14/07/2023.
//

import SwiftUI
import ComposableArchitecture


struct ContentFeature: ReducerProtocol {
  struct State {
    var path = StackState<Path.State>()
  }
  public enum Action {
    case path(StackAction<Path.State, Path.Action>)
  }

  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }
  }

  public struct Path: ReducerProtocol {
    public enum State {
      case int(IntFeature.State)
    }
    public enum Action {
      case int(IntFeature.Action)
    }
    public var body: some ReducerProtocolOf<Self> {
      Scope(state: /State.int, action: /Action.int) {
        IntFeature()
      }
    }
  }

}

struct ContentView: View {

  let store: StoreOf<ContentFeature>

  var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
      VStack {
        NavigationLink("Nav link to 1", state: ContentFeature.Path.State.int(.init(num: 1)))
      }
      .padding()
    } destination: { (state: ContentFeature.Path.State) in
      switch state {
      case .int:
        CaseLet(
          state: /ContentFeature.Path.State.int,
          action: ContentFeature.Path.Action.int
        ) {
          IntView(store: $0)
        }
      }
    }
  }
}

struct IntFeature: ReducerProtocol {
  struct State: Equatable {
    var num: Int
  }
  public enum Action {
  }
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      }
    }
  }
}

struct IntView: View {
  let store: StoreOf<IntFeature>

  @State var isDestVisible: Bool = false

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        Text("Number \(viewStore.num)")
        Button("Show 2") {
          isDestVisible = true
        }
      }
      .navigationDestination(isPresented: $isDestVisible) {
        Text("Destination 2")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(store: Store(initialState: .init(), reducer: ContentFeature()))
  }
}
