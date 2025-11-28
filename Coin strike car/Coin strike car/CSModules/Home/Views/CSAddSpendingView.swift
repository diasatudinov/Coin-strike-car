//
//  CSAddSpendingView.swift
//  Coin strike car
//
//

import SwiftUI

struct CSAddSpendingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CarViewModel
    @State var selectSpending: SpendingType
    @State private var value = ""
    @State private var date = Date.now
    @State private var notes = ""
    @State private var mileage = ""
    @State private var selectWork: WorkType?
    
    @State private var showWorksList = false
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12),
                                count: 4)
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    if let currentCar = viewModel.currentCar {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            
                            Text("\(currentCar.make) \(currentCar.model) \(currentCar.year)")
                                .font(.system(size: 24, weight: .bold))
                            
                        }.foregroundStyle(.white)
                    }
                }
                Spacer()
            }.padding(.horizontal, 20)
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                    
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(SpendingType.allCases, id: \.self) { type in
                                Button {
                                    selectSpending = type
                                } label: {
                                    VStack(spacing: 8) {
                                        Image(type.spendingIcon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 80)
                                        
                                        Text(type.rawValue)
                                            .font(.system(size: 10))
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .foregroundStyle(selectSpending == type ? .knopki:.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        
                        
                        Rectangle()
                            .fill(.osnovnyeElementy)
                            .frame(height: 1)
                            .padding(.horizontal, 50)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            dataCollectCell(icon: .valueIcon) {
                                HStack(alignment: .bottom) {
                                    TextField(text: $value) {
                                        Text("Value")
                                            .font(TextStyle.text.font)
                                            .foregroundStyle(.knopkaOff)
                                    }
                                    .font(TextStyle.text.font)
                                    .foregroundStyle(.white)
                                    
                                    Text("*")
                                        .font(TextStyle.h2.font)
                                        .foregroundStyle(.vtorostepenyeElementy)
                                }
                            }
                            
                            dataCollectCell(icon: .yearIcon) {
                                HStack(alignment: .bottom) {
                                    
                                    DatePicker(
                                        "",
                                        selection: $date,
                                        displayedComponents: .date
                                    ).labelsHidden()
                                        .tint(.osnovnyeElementy)
                                        .environment(\.colorScheme, .dark)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                    
                                    
                                    Text("*")
                                        .font(TextStyle.h2.font)
                                        .foregroundStyle(.vtorostepenyeElementy)
                                }
                            }
                            
                            dataCollectCell(icon: .notesIcon) {
                                HStack(alignment: .bottom) {
                                    TextField(text: $notes) {
                                        Text("Notes")
                                            .font(TextStyle.text.font)
                                            .foregroundStyle(.knopkaOff)
                                    }
                                    .font(TextStyle.text.font)
                                    .foregroundStyle(.white)
                                    .keyboardType(.numberPad)
                                    
                                    Text("*")
                                        .font(TextStyle.h2.font)
                                        .foregroundStyle(.vtorostepenyeElementy)
                                }
                            }
                            
                            if selectSpending == .service {
                                dataCollectCell(icon: .mileageIcon) {
                                    HStack(alignment: .bottom) {
                                        TextField(text: $mileage) {
                                            Text("Current Mileage, km")
                                                .font(TextStyle.text.font)
                                                .foregroundStyle(.knopkaOff)
                                        }
                                        .font(TextStyle.text.font)
                                        .foregroundStyle(.white)
                                        .keyboardType(.decimalPad)
                                        
                                        Text("*")
                                            .font(TextStyle.h2.font)
                                            .foregroundStyle(.vtorostepenyeElementy)
                                    }
                                }
                                
                                dataCollectCell(icon: .workIcon) {
                                    HStack(alignment: .bottom) {
                                        if let selectWork = selectWork {
                                            Text(selectWork.rawValue)
                                                .font(TextStyle.text.font)
                                                .foregroundStyle(.white)
                                            
                                            
                                        } else {
                                            Text("Select a work")
                                                .font(TextStyle.text.font)
                                                .foregroundStyle(.knopkaOff)
                                        }
                                        Spacer()
                                        Text("Select")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundStyle(.blue)
                                            .onTapGesture {
                                                withAnimation {
                                                    showWorksList = true
                                                }
                                            }
                                        
                                    }
                                }
                            }

                            
                            
                        }
                        
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 150)
                    .ignoresSafeArea(edges: .bottom)
                    
                }
            }
            .background(Color.bg.ignoresSafeArea())
            .blur(radius: showWorksList ? 1:0)
            .overlay {
                if showWorksList {
                    
                    VStack(alignment: .leading) {
                        ForEach(WorkType.allCases, id: \.self) { work in
                            HStack {
                                
                                Text(work.rawValue)
                                    .font(TextStyle.h3.font)
                                    .foregroundStyle(.white)
                                
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.selectWork = work
                                withAnimation {
                                    showWorksList = false
                                }
                            }
                            
                        }
                    }.padding(12)
                        .background(
                            UnevenRoundedRectangle(bottomLeadingRadius: 15, bottomTrailingRadius: 15)
                                .fill(.bg)
                        )
                        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 15, bottomTrailingRadius: 15))
                        .overlay {
                            UnevenRoundedRectangle(bottomLeadingRadius: 15, bottomTrailingRadius: 15)
                                .stroke(lineWidth: 1)
                                .fill(.osnovnyeElementy)
                        }
                    
                    
                }
            }
            .overlay(alignment: .bottom) {
                Button {
                    if let currentCar = viewModel.currentCar {
                        if checkDataFull() {
                            if selectSpending == .service {
                                if let selectWork = selectWork {
                                    viewModel.add(
                                        spending: Spending(
                                            spending: selectSpending,
                                            value: Decimal(string: value) ?? .zero,
                                            date: date,
                                            notes: notes,
                                            mileage: Decimal(string: mileage) ?? .zero,
                                            workType: selectWork),
                                        to: currentCar)
                                }
                            } else {
                                viewModel.add(
                                    spending: Spending(
                                        spending: selectSpending,
                                        value: Decimal(string: value) ?? .zero,
                                        date: date,
                                        notes: notes),
                                    to: currentCar)
                            }
                            
                            dismiss()
                        }
                    }
                } label: {
                    Text("Save")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(.osnovnyeElementy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(checkDataFull() ? .knopki : .knopkaOff)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 1)
                                .fill(.osnovnyeElementy)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                        
                }
            }
        }.background(Color.osnovnyeElementy.ignoresSafeArea())
            .hideKeyboardOnTap()
    }
    
    private func checkDataFull() -> Bool {
        if selectSpending == .service {
            return !value.isEmpty && !notes.isEmpty && !mileage.isEmpty && selectWork != nil
        } else {
            return !value.isEmpty && !notes.isEmpty
        }
        
    }
    
    private func dataCollectCell<Content: View>(
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(height: 36)
            
            HStack(spacing: 4) {
                content()
                
            }.overlay(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 1)
                    .fill(.white)
                    .frame(height: 1)
            }
        }
    }
}

#Preview {
    CSAddSpendingView(viewModel: CarViewModel(), selectSpending: .fuel)
}
