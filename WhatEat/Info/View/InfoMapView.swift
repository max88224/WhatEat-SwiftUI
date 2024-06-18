//
//  InfoMapView.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/20.
//

import SwiftUI
import _MapKit_SwiftUI

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct InfoMapView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var region: MKCoordinateRegion
    let coordinate: CLLocationCoordinate2D
    var markerTitle: String
    
    init(coordinate: CLLocationCoordinate2D, markerTitle: String) {
        self._region = State(initialValue: MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
        self.coordinate = coordinate
        self.markerTitle = markerTitle
        
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(coordinateRegion: $region, annotationItems: [AnnotatedItem(name: self.markerTitle, coordinate: self.coordinate)]) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    VStack(spacing: 8) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                        Text(item.name)
                            .font(.mediumText)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 22)
                .overlay {
                    Color.clear
                        .frame(width: 48, height: 48)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
                .padding(.leading, 24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    InfoMapView(coordinate: CLLocationCoordinate2D(latitude: 24, longitude: 120), markerTitle: "1234")
}
