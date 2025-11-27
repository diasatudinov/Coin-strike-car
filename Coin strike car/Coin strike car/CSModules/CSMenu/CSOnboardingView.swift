//
//  CSOnboardingView.swift
//  Coin strike car
//
//

import SwiftUI

struct CSOnboardingView: View {
    var getStartBtnTapped: () -> ()
    @State var count = 0
    
    var onbImage: Image {
        switch count {
        case 0:
            Image(.onboardingImg1CS)
        case 1:
            Image(.onboardingImg2CS)
        case 2:
            Image(.onboardingImg3CS)
        default:
            Image(.onboardingImg1CS)
        }
    }
    
    var onbTitle: String {
        switch count {
        case 0:
            "Track All Car Expenses"
        case 1:
            "Plan Maintenance\nEasily"
        case 2:
            "Smart Monthly Insights"
        default:
            "Smart Monthly Insights"
        }
    }
    
    var onbDescription: String {
        switch count {
        case 0:
            "Fuel, wash, repairs — neatly\norganized."
        case 1:
            "Oil changes, filters, brakes — all\nunder control."
        case 2:
            "See where your money goes at a glance."
        default:
            "Save your depth, duration, photos, emotions, and locations - build your personal underwater story."
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            onbImage
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(edges: .top)
            
            VStack {
                Text(onbTitle)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                
                Text(onbDescription)
                    .font(.system(size: 24, weight: .regular))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.knopki)
                
            }.padding(.horizontal, 10)
            
            Spacer()
            
            VStack {
                
                Button {
                    if count < 2 {
                        withAnimation {
                            count += 1
                        }
                    } else {
                        getStartBtnTapped()
                    }
                } label: {
                    Text(count < 2 ? "Next" : "Get Started")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(.osnovnyeElementy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(.knopki)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 30)
                }
            }.padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.bg)
        .ignoresSafeArea()
    }
}


#Preview {
    CSOnboardingView(getStartBtnTapped: {})
}
