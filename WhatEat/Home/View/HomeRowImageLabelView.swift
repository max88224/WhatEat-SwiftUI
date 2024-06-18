//
//  HomeRowImageLabelView.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/14.
//

import SwiftUI

protocol HomeRowImageLabelViewDelegate {
    
    func rightButtonAction()
}

struct HomeRowImageLabelView: View {
    var delegate: HomeRowImageLabelViewDelegate? = nil
    let title: String
    let storeModel: StoreModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(self.title)
                    .font(.mediumSubTitle)
                Spacer()
                if self.delegate != nil {
                    Button(action: {
                        self.delegate?.rightButtonAction()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            
            NavigationLink(destination: InfoView(viewModel: InfoViewModel(storeModel: self.storeModel))) {
                    VStack(alignment: .leading, spacing: 8) {
                        Group {
                            if let image = self.storeModel.image.convertToBase64StringImage() {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                            }
                            else {
                                Image("common_no_image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                            }
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
                        Text(self.storeModel.name)
                            .font(.regularText)
                    }
            }
        }
    }
}
