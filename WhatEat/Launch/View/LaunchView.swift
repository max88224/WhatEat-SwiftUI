//
//  LaunchView.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/14.
//

import SwiftUI

struct LaunchView: View {
    @Binding var isShowSelf: Bool
    
    let viewModel = LaunchViewModel()
    
    var body: some View {
        ProgressView("Loading")
            .task {
                await self.viewModel.setupDefaultData()
                self.viewModel.setAreaList()
                self.isShowSelf = false
            }
    }
}

#Preview {
    LaunchView(isShowSelf: Binding.constant(true))
}
