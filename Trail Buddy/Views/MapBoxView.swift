//
//  MapBoxView.swift
//  Trail Buddy
//
//  Created by Cédric Derache on 05/07/2021.
//

import Foundation
import Mapbox
import SwiftUI

struct MapBoxView: UIViewRepresentable {
    typealias UIViewType = MGLMapView

    private let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: MGLStyle.streetsStyleURL)

    // MARK: - Configuring UIViewRepresentable protocol

    func makeUIView(context: UIViewRepresentableContext<MapBoxView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapBoxView>) {}

    func makeCoordinator() -> MapBoxView.Coordinator {
        Coordinator(self)
    }

    // MARK: - Configuring MGLMapView

    func styleURL(_ styleURL: URL) -> MapBoxView {
        mapView.styleURL = styleURL
        return self
    }

    func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> MapBoxView {
        mapView.centerCoordinate = centerCoordinate
        return self
    }

    func zoomLevel(_ zoomLevel: Double) -> MapBoxView {
        mapView.zoomLevel = zoomLevel
        return self
    }

    // MARK: - Implementing MGLMapViewDelegate

    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MapBoxView

        init(_ control: MapBoxView) {
            self.control = control
        }

        func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {}

        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            return nil
        }

        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
    }
}
