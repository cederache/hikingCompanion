//
//  MainView.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTabIndex = 1
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            MapView()
            .tabItem {
                Image(systemName: "map.fill")
                    .font(.system(size: 25))
                Text("map")
            }
            .tag(1)
            
            ListView()
            .tabItem {
                Image(systemName: "list.bullet.indent")
                    .font(.system(size: 25))
                Text("list")
            }
            .tag(2)
            
            SettingsView()
            .tabItem {
                Image(systemName: "gear")
                    .font(.system(size: 25))
                Text("settings")
            }
            .tag(3)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
