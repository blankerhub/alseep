//
//  Heading.swift
//  realsleep
//
//  Created by Ar on 5/6/22.
//

import SwiftUI



struct HeadingOne: View {
    @State var title: String
    var body: some View {
        HStack{
            Text(title).styleAsHeading()
                .padding()
                .padding(.leading, 20)
                .foregroundColor(Color.mainLighest)
                
        Spacer()
        }
    }
}

struct Heading_Previews: PreviewProvider {
    static var previews: some View {
        HeadingOne(title: "some heading")
    }
}
