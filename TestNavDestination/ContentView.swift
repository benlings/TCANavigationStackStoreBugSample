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
    @PresentationState var dest: DestFeature.State? = nil
  }
  public enum Action {
    case showDest
    case dest(PresentationAction<DestFeature.Action>)
  }
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .showDest:
        state.dest = .init()
        return .none

      case .dest:
        return .none
      }
    }
    .ifLet(\.$dest, action: /Action.dest) {
      DestFeature()
    }
  }
}

struct IntView: View {
  let store: StoreOf<IntFeature>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        Text("Number \(viewStore.num)")
        Button("Show 2") {
          viewStore.send(.showDest)
        }
      }
      .navigationDestination(
        store: store.scope(state: \.$dest, action: { .dest($0) })
      ) {
        DestView(store: $0)
      }
    }
  }
}

struct DestFeature: ReducerProtocol {
  struct State: Equatable {
  }
  enum Action {
  }
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      }
    }
  }
}

struct DestView: View {
        let store: StoreOf<DestFeature>

  var body: some View {
    Text("Destination 2")
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(store: Store(initialState: .init(), reducer: ContentFeature()))
  }
}
