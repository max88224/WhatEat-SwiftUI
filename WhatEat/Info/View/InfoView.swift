//
//  InfoView.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/17.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let parking = CLLocationCoordinate2D(
            latitude: 24.13, longitude: 120.63
        )
}

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: InfoViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(InfoViewModelRowType.allCases, id: \.self) { type in
                    switch type {
                    case .image:
                        self.onlyImageView(image: self.viewModel.storeModel.image.convertToBase64StringImage())
                    case .name:
                        self.titleAndTextView(title: type.title, text: self.viewModel.storeModel.name)
                    case .bigArea:
                        self.titleAndTextView(title: type.title, text: self.viewModel.storeModel.bigAreaName)
                    case .smallArea:
                        self.titleAndTextView(title: type.title, text: self.viewModel.storeModel.smallAreaName)
                    case .food:
                        self.titleAndTextView(title: type.title, text: self.viewModel.storeModel.foodName)
                    case .score:
                        self.titleAndTextView(title: type.title, text: self.viewModel.storeModel.displayScore)
                    case .address:
                        self.addressView()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 24)
            
        }
        .navigationTitle("店家資訊")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
            }
            .tint(Color.appColor)
        )
        .onAppear {
            CommonSystemManager.shared.tabViewVisibility = .hidden
        }
    }
    
    @ViewBuilder
    func titleAndTextView(title: String, text: String) -> some View {
        HStack(spacing: 16) {
            Text(title)
                .frame(width: 50, alignment: .trailing)
                .font(.mediumText)
                .foregroundColor(.secondary)
            Text(text)
                .font(.regularText)
                .foregroundColor(Color.appColor)
        }
    }
    
    @ViewBuilder
    func onlyImageView(image: UIImage?) -> some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 300)
                .clipped()
        }
    }
    
    @ViewBuilder
    func addressView() -> some View {
        HStack(spacing: 16) {
            Text(InfoViewModelRowType.address.title)
                .frame(width: 50, alignment: .trailing)
                .font(.mediumText)
                .foregroundColor(.secondary)
            Text(self.viewModel.storeModel.address)
                .foregroundColor(Color.appColor)
            if let coordinate = self.viewModel.coordinate {
                NavigationLink(destination: InfoMapView(coordinate: coordinate, markerTitle: self.viewModel.storeModel.name)) {
                    Text("查看")
                }
            }
        }
        .font(.regularText)
    }
}

#Preview {
    InfoView(viewModel: InfoViewModel(storeModel: StoreModel(id: 0)))
}
