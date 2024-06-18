//
//  AddFoodView.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/22.
//

import SwiftUI

struct AddFoodView: View {
    
    @Binding var isShowSelf: Bool
    
    @StateObject var viewModel = AddFoodViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isShowSelf = false
                }) {
                    Image(systemName: "xmark")
                }
                .tint(Color.appColor)
            }
            .padding(.horizontal, 32)
            
            ForEach(AddFoodViewModelRowType.allCases, id: \.self) { type in
                VStack(alignment: .leading, spacing: 8) {
                    switch type {
                    case .name:
                        self.titleAndTextFieldView(type: type)
                    case .image:
                        self.titleAndEmojiView(type: type)
                    }
                }
            }
            .padding(.horizontal, 32)
            
            HStack {
                Button(action: {
                    self.viewModel.clearAllData()
                }) {
                    Text("清除")
                        .frame(width: 120, height: 40)
                        
                }
                .foregroundColor(Color.appColor)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
                
                Button(action: {
                    self.viewModel.insetFoodToDatabase()
                    if !self.viewModel.isShowAlert {
                        self.isShowSelf = false
                    }
                }) {
                    Text("新增")
                        .frame(width: 120, height: 40)
                }
                .foregroundColor(Color(.systemBackground))
                .background(Color.appColor)
                .cornerRadius(12)
            }
            .padding(56)
            .background(
                Color(.systemBackground)
                    .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
            )
        }
        .padding(.top, 32)
        .ignoresSafeArea()
        .alert(isPresented: $viewModel.isShowAlert) {
            Alert(title: Text("新增失敗"), message: Text("「\(self.viewModel.errorType?.title ?? "")」不可空白"), dismissButton: .default(Text("確定")))
        }
    }
    
    @ViewBuilder
    private func titleAndTextFieldView(type: AddFoodViewModelRowType) -> some View {
        HStack(spacing: 4) {
            Text(type.title)
                .font(.mediumText)
                .foregroundColor(.secondary)
            if type.isRequired {
                Text("*")
                    .foregroundColor(.red)
            }
        }
        TextField("", text: $viewModel.name)
        Divider()
    }
    
    @ViewBuilder
    private func titleAndEmojiView(type: AddFoodViewModelRowType) -> some View {
        HStack(spacing: 4) {
            Text(type.title)
                .font(.mediumText)
                .foregroundColor(.secondary)
            if type.isRequired {
                Text("*")
                    .foregroundColor(.red)
            }
        }
        .padding(.top, 16)
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
                ForEach(FoodModel.imageList.indices, id: \.self) { index in
                    Text(FoodModel.imageList[index])
                        .font(.system(size: 40))
                        .background(self.viewModel.imageSelectedIndex == index ? Color(.systemGreen).opacity(0.5) : .clear)
                        .cornerRadius(6)
                        .onTapGesture {
                            self.viewModel.image = FoodModel.imageList[index]
                            self.viewModel.imageSelectedIndex = index
                        }
                }
            }
        }
    }
}

#Preview {
    AddFoodView(isShowSelf: Binding.constant(true))
}
