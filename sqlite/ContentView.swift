//
//  ContentView.swift
//  sqlite
//
//  Created by Nickolay Truhin on 03.11.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ForEach(MainScreenModel.State.allCases, id: \.rawValue) { state in
                MainScreen(vm: .init(state)).tabItem { Text(state.rawValue) }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
