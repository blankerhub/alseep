//
//  Debug.swift
//  realsleep
//
//  Created by Ar on 5/14/22.
//

import SwiftUI

struct Debug: View {
    var body: some View {
        ZStack{
            //HealthDataObservations()
            SensorDataViewer()
        }
    }
}

struct Debug_Previews: PreviewProvider {
    static var previews: some View {
        Debug()
    }
}
