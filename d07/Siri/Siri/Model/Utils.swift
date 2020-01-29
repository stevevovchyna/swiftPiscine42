//
//  Utils.swift
//  Siri
//
//  Created by Steve Vovchyna on 29.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import Foundation

func fToC(_ temperature: Double) -> String {
    return String(describing: ((temperature - 32) * (5 / 9)).rounded())
}
