//
//  CSMenuContainerView.swift
//  Coin strike car
//
//

import SwiftUI

struct CSMenuContainerView: View {
    @AppStorage("firstOpenCS") var firstOpen: Bool = true
    @StateObject var carViewModel = CarViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                if firstOpen {
                    CSOnboardingView(getStartBtnTapped: {
                        firstOpen = false
                    })
                } else {
                    if carViewModel.currentCar != nil {
                        BBMenuView(carViewModel: carViewModel)
                    } else {
                        CSAddCarView(carViewModel: carViewModel)
                    }
                    
                }
            }
        }
    }
}

struct BBMenuView: View {
    @State var selectedTab = 0
    @ObservedObject var carViewModel: CarViewModel
    private let tabs = ["My dives", "Calendar", "Stats", "Stats"]
    
    var body: some View {
        ZStack {
            
            switch selectedTab {
            case 0:
                CSHomeView(viewModel: carViewModel)
            case 1:
                CSExpensesView(viewModel: carViewModel)
            case 2:
                CSStatisticsView(viewModel: carViewModel)
            case 3:
                CSCalendarView(viewModel: carViewModel)
            default:
                Text("default")
            }
            VStack(spacing: 0) {
                Spacer()
                
                Rectangle()
                    .fill(.osnovnyeElementy)
                    .frame(height: 1)
                    
                
                HStack(spacing: 25) {
                    ForEach(0..<tabs.count) { index in
                        Button(action: {
                            selectedTab = index
                        }) {
                            VStack {
                                Image(selectedTab == index ? selectedIcon(for: index) : icon(for: index))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 36)
                                
                                Text(text(for: index))
                                    .font(TextStyle.text.font)
                                    .foregroundStyle(.white)
                            }
                            
                        }
                        
                    }
                }
                .padding(.vertical, 5)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity)
                .background(.bg)
                
            }
            .ignoresSafeArea()
            
            
        }.sheet(isPresented: $carViewModel.showAddNewCar, content: {
            CSAddCarView(carViewModel: carViewModel)
        })
    }
    
    private func icon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconCS"
        case 1: return "tab2IconCS"
        case 2: return "tab3IconCS"
        case 3: return "tab4IconCS"
        default: return ""
        }
    }
    
    private func selectedIcon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconSelectedCS"
        case 1: return "tab2IconSelectedCS"
        case 2: return "tab3IconSelectedCS"
        case 3: return "tab4IconSelectedCS"
        default: return ""
        }
    }
    
    private func text(for index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Expenses"
        case 2: return "Statistics"
        case 3: return "Calendar"
        default: return ""
        }
    }
}

#Preview {
    CSMenuContainerView()
}
