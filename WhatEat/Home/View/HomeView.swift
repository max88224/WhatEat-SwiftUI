//
//  HomeView.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/11.
//

import SwiftUI

struct HomeView: View, HomeRowImageLabelViewDelegate {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var systemShared: CommonSystemManager

    @StateObject var dbShared = SQLiteDatabase.shared
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(HomeViewModelRowType.allCases, id: \.self) { type in
                    switch type {
                    case .hello:
                        self.helloView()
                    case .near:
                        self.nearView(type: type)
                    case .foodType:
                        self.foodView(type: type)
                    case .featured:
                        if let id = self.viewModel.featuredId, let storeModel = self.dbShared.storeList.first(where: { $0.id == id }) {
                            HomeRowImageLabelView(title: type.title, storeModel: storeModel)
                        }
                    case .random:
                        if let id = self.viewModel.randomId, let storeModel = self.dbShared.storeList.first(where: { $0.id == id }) {
                            HomeRowImageLabelView(delegate: self, title: type.title, storeModel: storeModel)
                        }
                    }
                }
            }
            .padding(32)
        }
        .navigationBarItems(leading:
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("陳威任")
                        .font(.regularSubTitle)
                        .foregroundColor(Color.appColor)
                }
            }
        )
        .navigationBarItems(trailing:
            Button(action: {
                self.viewModel.isShowActionSheet.toggle()
            }) {
                Image(systemName: "ellipsis")
            }
            .actionSheet(isPresented: $viewModel.isShowActionSheet) {
                ActionSheet(
                    title: Text("功能列表"), buttons: [
                        .default(Text("新增店家")) {
                            self.viewModel.selectedNearStoreModel = nil
                            self.viewModel.isShowAddStoreSheet.toggle()
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $viewModel.isShowAddStoreSheet) {
                AddStoreView(viewModel: AddStoreViewModel(nearStoreModel: self.viewModel.selectedNearStoreModel), isShowSelf: $viewModel.isShowAddStoreSheet)
            }
        )
        .tint(Color.appColor)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.viewModel.isNavigationAppear = true
            self.systemShared.tabViewVisibility = .visible
            
            DispatchQueue.main.async {
                self.viewModel.isNavigationAppear = false
            }
        }
        .onChange(of: self.dbShared.storeList.count) { _ in
            self.viewModel.changeStoreListData()
        }
    }
    
    func rightButtonAction() {
        self.viewModel.setRandomStoreId()
    }
    
    @ViewBuilder
    func helloView() -> some View {
        Text("Hi \(self.viewModel.timePeriodType.rawValue)！")
            .font(.mediumTitle)
    }
    
    @ViewBuilder
    func nearView(type: HomeViewModelRowType) -> some View {
        VStack(alignment: .leading) {
            Text(type.title)
                .font(.mediumSubTitle)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(self.systemShared.nearStoreList.indices, id: \.self) { index in
                        let model = self.systemShared.nearStoreList[index]
                        VStack(alignment: .leading, spacing: 8) {
                            Image(uiImage: model.image.convertToBase64StringImage()!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 180)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            HStack {
                                Text(model.name)
                                    .foregroundColor(Color.appColor)
                                    .font(.regularText)
                                Image(systemName: "plus.circle.fill")
                                    .onTapGesture {
                                        self.viewModel.selectedNearStoreModel = model
                                        self.viewModel.isShowAddStoreSheet.toggle()
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.horizontal, -32)
        }
    }
    
    @ViewBuilder 
    func foodView(type: HomeViewModelRowType) -> some View {
        VStack(alignment: .leading) {
            Text(type.title)
                .font(.mediumSubTitle)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(SQLiteDatabase.shared.foodList, id: \.self.id) { item in
                        NavigationLink(destination: SearchResultListView(viewModel: SearchResultListViewModel(filterModel: SearchFilterModel(foodId: item.id), isNavigationAppear: self.viewModel.isNavigationAppear))
                            .navigationTitle("店家列表")) {
                            VStack(spacing: 8) {
                                Text(item.image)
                                    .font(.system(size: 60))
                                Text(item.name)
                                    .foregroundColor(Color.appColor)
                                    .font(.regularText)
                            }
                        }
                        .isDetailLink(false)
                    }
                    VStack(spacing: 8) {
                        Text("➕")
                            .font(.system(size: 60))
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                        Text("新增")
                            .foregroundColor(.gray)
                            .font(.regularText)
                    }
                    .onTapGesture {
                        self.viewModel.isShowAddFoodSheet.toggle()
                    }
                    .sheet(isPresented: $viewModel.isShowAddFoodSheet) {
                        AddFoodView(isShowSelf: $viewModel.isShowAddFoodSheet)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.horizontal, -32)
        }
    }
}

#Preview {
    HomeView()
}
