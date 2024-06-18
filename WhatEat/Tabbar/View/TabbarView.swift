//
//  TabbarView.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/13.
//

import SwiftUI

struct TabbarView: View {
    
    @State var isLaunch = true
    
    @StateObject var systemShared = CommonSystemManager.shared
    
    var body: some View {
        if self.isLaunch {
            LaunchView(isShowSelf: $isLaunch)
        }
        else {
            TabView {
                NavigationView {
                    HomeView()
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("首頁")
                }
                .environmentObject(self.systemShared)
                .toolbar(self.systemShared.tabViewVisibility, for: .tabBar)
                
                
                Text("查詢")
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("查詢店家")
                    }
                
            }
        }
    }
    
    func goToHomeView() {
        self.isLaunch = false
    }
}

#Preview {
    TabbarView()
}
