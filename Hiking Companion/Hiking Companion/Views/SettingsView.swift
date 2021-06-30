//
//  SettingsView.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Version")
                    
                    Spacer()
                    
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
                }
            }
            .navigationTitle(Text(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
