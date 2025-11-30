//
//  DatesListView.swift
//  Coin strike car
//
//

import SwiftUI

struct DatesListView: View {
    @ObservedObject var viewModel: CarViewModel
    @Binding var dataPeriod: FilterDataPeriod
    @Binding var showDatesList: Bool
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(FilterDataPeriod.allCases, id: \.self) { item in
                    HStack {
                        Button {
                            dataPeriod = item
                            showDatesList = false
                        } label: {
                            
                            Text("\(item.rawValue)")
                                .font(TextStyle.h3.font)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            
            
        }
        .padding(20)
        .background(.bg)
        .clipShape(Rectangle())
    }
}

#Preview {
    DatesListView(viewModel: CarViewModel(), dataPeriod: .constant(.thisMonth), showDatesList: .constant(true)
    )
}
