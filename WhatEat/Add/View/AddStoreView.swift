//
//  AddStoreView.swift
//  WhatEat
//
//  Created by Chen William on 2024/5/14.
//

import SwiftUI
import PhotosUI

protocol AddStoreViewDelegate {
    
    func dismissButtonAction()
}

struct AddStoreView: View {

    @StateObject var viewModel: AddStoreViewModel
    
    @Binding var isShowSelf: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
                ScrollView(showsIndicators: false) {
                    ForEach(AddStoreViewModelRowType.allCases, id: \.self) { type in
                        VStack(alignment: .leading, spacing: 8) {
                            switch type {
                            case .name:
                                self.titleAndTextFieldView(type: type, textBinding: $viewModel.name)
                            case .bigArea:
                                self.titleAndPickerView(type: type, textBinding: $viewModel.bigArea)
                            case .smallArea:
                                self.titleAndPickerView(type: type, textBinding: $viewModel.smallArea)
                            case .food:
                                self.titleAndPickerView(type: type, textBinding: $viewModel.food)
                            case .score:
                                self.titleAndScoreView(type: type)
                            case .address:
                                self.titleAndTextFieldView(type: type, textBinding: $viewModel.address)
                            case .image:
                                self.titleAndPhotosPickerView(type: type)
                            }
                            if type != .image {
                                Divider()
                            }
                        }
                    }
                }
                .foregroundColor(Color.appColor)
                .font(.regularText)
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
                        self.viewModel.insetStoreToDatabase()
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
            .alert(isPresented: $viewModel.isShowAlert) {
                Alert(title: Text("新增失敗"), message: Text("「\(self.viewModel.errorType?.title ?? "")」不可空白"), dismissButton: .default(Text("確定")))
            }
            
            if self.viewModel.isShowPicker {
                self.pickerView()
            }
                
        }
        .ignoresSafeArea()
    }
    
    func getPickerSelectionBinding(type: AddStoreViewModelRowType) -> Binding<Int>? {
        switch type {
        case .name, .score, .address, .image:
            return nil
        case .bigArea:
            return $viewModel.bigAreaSelectedIndex
        case .smallArea:
            return $viewModel.smallAreaSelectedIndex
        case .food:
            return $viewModel.foodSelectedIndex
        }
    }
    
    @ViewBuilder
    private func titleAndTextFieldView(type: AddStoreViewModelRowType, textBinding: Binding<String>) -> some View {
        HStack(spacing: 4) {
            Text(type.title)
                .font(.mediumText)
                .foregroundColor(.secondary)
            if type.isRequired {
                Text("*")
                    .foregroundColor(.red)
            }
        }
        TextField(type.placeholder, text: textBinding)
    }
    
    @ViewBuilder
    private func titleAndPickerView(type: AddStoreViewModelRowType, textBinding: Binding<String>) -> some View {
        HStack(spacing: 4) {
            Text(type.title)
                .font(.mediumText)
                .foregroundColor(.secondary)
            if type.isRequired {
                Text("*")
                    .foregroundColor(.red)
            }
        }
        Text(textBinding.wrappedValue.isEmpty ? type.placeholder : textBinding.wrappedValue)
            .foregroundColor(textBinding.wrappedValue.isEmpty ? Color(.systemGray3) : Color.appColor)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .background(Color(.systemBackground))
            .onTapGesture {
                guard self.viewModel.getPickerIndex(type: type) != nil else {
                    return
                }
                if textBinding.wrappedValue.isEmpty {
                    self.viewModel.setPickerSelected(type: type)
                }
                self.viewModel.pickRowType = type
                self.viewModel.isShowPicker.toggle()
            }
    }
    
    @ViewBuilder
    private func titleAndScoreView(type: AddStoreViewModelRowType) -> some View {
        HStack(spacing: 4) {
            Text(type.title)
                .font(.mediumText)
                .foregroundColor(.secondary)
            if type.isRequired {
                Text("*")
                    .foregroundColor(.red)
            }
        }
        HStack {
            ForEach(self.viewModel.minScore...self.viewModel.maxScore, id: \.self) { count in
                Text(count <= self.viewModel.score ?? 0 ? "💛" : "🤍")
                    .onTapGesture {
                        self.viewModel.score = count
                    }
            }
        }
    }
    
    @ViewBuilder
    private func titleAndPhotosPickerView(type: AddStoreViewModelRowType) -> some View {
        Text(type.title)
            .font(.mediumText)
            .foregroundColor(.secondary)
        
        PhotosPicker(selection: $viewModel.selectedImagePickItem, matching: .any(of: [.images])) {
            if self.viewModel.image == nil {
                Color.clear
                    .frame(maxWidth: .infinity, minHeight: 300)
                    .overlay {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        
                    }
            }
            else {
                Image(uiImage: self.viewModel.image!)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 300)
                    .clipped()
            }
        }
        .onChange(of: self.viewModel.selectedImagePickItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    self.viewModel.image = UIImage(data: data)
                }
            }
        }
    }
    
    @ViewBuilder
    private func pickerView() -> some View {
        let type = self.viewModel.pickRowType
        VStack(spacing: 0) {
            Color.black
                .opacity(0.7)
                .onTapGesture {
                    self.viewModel.isShowPicker = false
                }
            Picker("", selection: self.getPickerSelectionBinding(type: type)!) {
                ForEach(self.viewModel.getPickerList(type: type).indices, id: \.self) { index in
                    Text(self.viewModel.getPickerList(type: type)[index])
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxHeight: 220)
            .background(Color(.systemGray6))
            .onChange(of: self.viewModel.getPickerIndex(type: type)) { newValue in
                self.viewModel.setPickerSelected(type: type)
                if type == .bigArea {
                    self.viewModel.smallArea = ""
                    self.viewModel.smallAreaSelectedIndex = 0
                }
            }
        }
    }
}

#Preview {
    AddStoreView(viewModel: AddStoreViewModel(), isShowSelf: Binding.constant(true))
}


