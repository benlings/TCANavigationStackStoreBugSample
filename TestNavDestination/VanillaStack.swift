//
//  ContentView.swift
//  Test Navigation Path + Destination
//
//  Created by Ben Lings on 14/07/2023.
//

import SwiftUI
import ComposableArchitecture

enum VanillaStack {
  struct ContentFeature: ReducerProtocol {
    struct State {
      var path = [PathElement]()
      var int: IntFeature.State? = nil
    }
    public enum Action {
      case showInt(Int)
      case pathChanged([PathElement])
      case int(IntFeature.Action)
    }

    var body: some ReducerProtocolOf<Self> {
      Reduce { state, action in
        switch action {
        case .showInt(let int):
          state.int = .init(num: int)
          state.path.append(.int)
          return .none
        case .pathChanged(let path):
          state.path = path
          return .none
        case .int:
          return .none
        }
      }
      .ifLet(\.int, action: /Action.int) {
        IntFeature()
      }
    }

    enum PathElement: Equatable {
      case int
    }

  }
  
  struct ContentView: View {

    let store: StoreOf<ContentFeature>

    struct ViewState: Equatable {
      let path: [ContentFeature.PathElement]
      init(_ state: ContentFeature.State) {
        self.path = state.path
      }
    }

    var body: some View {
      WithViewStore(store, observe: ViewState.init) { viewStore in
        NavigationStack(path: viewStore.binding(
          get: \.path,
          send: ContentFeature.Action.pathChanged
        )) {
          VStack {
            Button("Nav link to 1") {
              viewStore.send(.showInt(1))
            }
          }
          .padding()
          .navigationDestination(for: ContentFeature.PathElement.self) { element in
            NavigationDestinationView(store: store, element: element)
          }
        }
      }
    }
  }

  struct NavigationDestinationView: View {
    let store: StoreOf<ContentFeature>
    let element: ContentFeature.PathElement

    var body: some View {

      IfLetStore(store.scope(state: \.int, action: ContentFeature.Action.int)) { intStore in
        IntView(store: intStore)
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
  
}

struct VanillaStackContentView_Previews: PreviewProvider {
  static var previews: some View {
    VanillaStack.ContentView(store: Store(initialState: .init(), reducer: VanillaStack.ContentFeature()))
  }
}

