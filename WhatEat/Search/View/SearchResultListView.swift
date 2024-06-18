//
//  SearchResultListView.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/15.
//

import SwiftUI

struct SearchResultListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: SearchResultListViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 16) {
                    ForEach(FilterType.allCases, id: \.self) { type in
                        let isSelected = self.viewModel.isDropDown && self.viewModel.selectedFilterType == type
                        let isHaveData = self.viewModel.getSelectedName(type: type) != nil
                        HStack(spacing: 4) {
                            Text(self.viewModel.getSelectedName(type: type) ?? type.title)
                                .font(isHaveData ? .mediumText : .regularText)
                                .foregroundColor(isHaveData ? Color(.systemGreen) : Color(.systemGray))
                            Image(systemName: isSelected ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                        }
                        .onTapGesture {
                            self.viewModel.selectedFilterType = type
                            if !self.viewModel.getDropDownList().isEmpty {
                                self.viewModel.isDropDown.toggle()
                            }
                        }
                    }
                    Spacer()
                    Text("清除")
                        .font(.regularText)
                        .foregroundColor(Color.appColor)
                        .onTapGesture {
                            self.viewModel.clearAllFilter()
                            self.viewModel.isDropDown = false
                        }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !self.viewModel.isDropDown {
                    Divider()
                }
                
                ZStack(alignment: .center) {
                    GeometryReader { geometry in
                        if self.viewModel.storeList.isEmpty {
                            self.noDataView()
                                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                        }
                        else {
                            List {
                                ForEach($viewModel.storeList, id: \.self.id) { $item in
                                    VStack(spacing: 24) {
                                        ZStack {
                                            VStack(alignment: .leading, spacing: 8) {
                                                HStack {
                                                    Text(item.name)
                                                        .font(.regularSubTitle)
                                                    Spacer()
                                                    Text(item.displayScore)
                                                }
                                                if !item.address.isEmpty {
                                                    Text(item.address)
                                                        .font(.regularText)
                                                }
                                            }
                                            NavigationLink(destination: InfoView(viewModel: InfoViewModel(storeModel: item))) {
                                                EmptyView()
                                            }
                                            .opacity(0)
                                        }
                                    }
                                }
                                .onDelete(perform: delete)
                            }
                            .listStyle(.plain)
                        }
                        if self.viewModel.isDropDown {
                            VStack(spacing: 16) {
                                ScrollView() {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(self.viewModel.getDropDownList().indices, id: \.self) { index in
                                            let list = self.viewModel.getDropDownList()
                                            Text(list[index])
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .contentShape(Rectangle()) // 增加點擊範圍
                                                .onTapGesture {
                                                    self.viewModel.setDropDownSelected(index: index)
                                                    self.viewModel.isDropDown.toggle()
                                                }
                                            if list.count - 1 != index {
                                                Divider()
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                                .frame(maxHeight: 200)
                                
                                Color.black.opacity(0.7)
                                    .ignoresSafeArea()
                                    .onTapGesture {
                                        self.viewModel.isDropDown = false
                                    }
                            }
                            .background(Color(.systemBackground))
                        }
                    }
                }
            }
        }
        .foregroundColor(Color.appColor)
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
            CommonSystemManager.shared.tabViewVisibility = self.viewModel.isNavigationAppear ? .visible : .hidden
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            SQLiteDatabase.shared.deleteStoreTable(id: self.viewModel.storeList[index].id)
        }
        self.viewModel.storeList.remove(atOffsets: offsets)
    }
    
    @ViewBuilder
    func noDataView() -> some View {
        VStack(spacing: 16) {
            Image("common_no_data")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
            Text("沒有資料")
        }
    }
}

#Preview {
    SearchResultListView(viewModel: SearchResultListViewModel(filterModel: SearchFilterModel()))
}
