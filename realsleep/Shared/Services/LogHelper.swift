//
//  logHelper.swift
//  realsleep
//
//  Created by Ar on 5/29/22.
//

import Foundation

struct LogHelper {
    static var shared = LogHelper();
    func debugLog(message: String){
        print(message);
    }
    func debugLogError(message: String){
        print(message);
    }
}
