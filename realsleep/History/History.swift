//
//  History.swift
//  realsleep
//
//  Created by Ar on 5/1/22.
//

import SwiftUI

struct History: View {
    var body: some View {
        GeometryReader { bounds in
            VStack {
                Text("History")
            }
            .frame(width: bounds.size.width, height: bounds.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        .background(Color.neuBackground)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
