//
//  MusicBar.swift
//  realsleep
//
//  Created by Ar on 5/6/22.
//

import SwiftUI

struct MusicBar: View {
    var body: some View {
        HStack{
            Button(action:{}){
                VStack{
                    Text("currently")
                        .font(.caption)
                    Text("Playing")
                        .font(.body)
                }.padding(.trailing,30)
                    .padding(.leading,30)
            }.buttonStyle(NeoButtonStyle())
            Button(action:{}){
                HStack{
                    VStack{
                        Text("Apple")
                            .font(.caption)
                        Text("Music")
                            .font(.body)
                    }.padding(.trailing,10)
                        .padding(.leading,30)
                    NavButton()
                }
            }.buttonStyle(NeoButtonStyle())
        }
    }
}

struct MusicBar_Previews: PreviewProvider {
    static var previews: some View {
        MusicBar()
    }
}
