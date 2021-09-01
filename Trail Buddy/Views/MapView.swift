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
            MapBoxView()
                .centerCoordinate(.init(latitude: 37.791293, longitude: -122.396324))
                .zoomLevel(16)
        }
    }
}

struct HikingMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
