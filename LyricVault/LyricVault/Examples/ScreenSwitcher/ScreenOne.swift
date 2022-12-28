//
//  Screen1.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-20.
//

import SwiftUI

struct ScreenOne: View {
    
    @EnvironmentObject var router: TabRouter
    
    var body: some View {
        ZStack {
            VStack{
                Text("Screen 1")
                    .bold()
                    .foregroundColor(.white)
                
                Button {
                    router.change(to: .two)
                } label: {
                    Text("Switch to Screen 2")
                }
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .background(.mint)
        .clipped()
    }
}

struct ScreenOne_Previews: PreviewProvider {
    static var previews: some View {
        ScreenOne()
            .environmentObject(TabRouter())
    }
}
