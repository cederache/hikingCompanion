//
//  MapView.swift
//  Hiking Companion
//
//  Created by Cédric Derache on 30/06/2021.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        NavigationView {
            Text("Hiking Map View")
            .navigationTitle(Text("map"))
        }
    }
}

struct HikingMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
