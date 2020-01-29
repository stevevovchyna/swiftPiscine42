//
//  Extensions.swift
//  Siri
//
//  Created by Steve Vovchyna on 29.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
