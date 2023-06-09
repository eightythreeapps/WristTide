//
//  ContentView.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 11/04/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TideStationListView()
            .environmentObject(ViewModelFactory.makeTideStationListViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModelFactory.makeTideStationListViewModel())
    }
}
