//
//  InfoViewModel.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/20.
//

import Foundation
import CoreLocation
import _MapKit_SwiftUI

enum InfoViewModelRowType: CaseIterable {
    case image
    case name
    case bigArea
    case smallArea
    case food
    case score
    case address
    
    var title: String {
        switch self {
        case .image:
            return ""
        case .name:
            return "名稱"
        case .bigArea:
            return "縣市"
        case .smallArea:
            return "區域"
        case .food:
            return "類型"
        case .score:
            return "分數"
        case .address:
            return "地址"
        }
    }
}

class InfoViewModel: ObservableObject {
    
    var storeModel: StoreModel
    
    @Published var coordinate: CLLocationCoordinate2D?
    
    init(storeModel: StoreModel) {
        self.storeModel = storeModel
        self.addressFindLocation(address: storeModel.address)
        self.updateEnterCount()
    }
    
    /// 用地址找座標
    private func addressFindLocation(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let coordinate = placemarks?.first?.location?.coordinate else {
                return
            }
            self.coordinate = coordinate
        }
    }
    
    /// 更新近來次數
    private func updateEnterCount() {
        SQLiteDatabase.shared.updateStoreTableEnterCount(model: self.storeModel)
    }
}
