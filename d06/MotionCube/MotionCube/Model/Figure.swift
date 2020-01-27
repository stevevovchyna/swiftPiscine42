//
//  Figure.swift
//  MotionCube
//
//  Created by Steve Vovchyna on 27.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import Foundation
import UIKit

enum Figures {
    case circle
    case square
}

class Figure: UIView {
    var type : Figures
    let possibleShapes: [Figures] = [.circle, .square]
    var figureSize: CGFloat = 100.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init() was not implemented")
    }
    
    init(location: CGPoint) {
        let frame = CGRect(x: location.x - (figureSize / 2), y: location.y, width: figureSize, height: figureSize)
        type = possibleShapes.randomElement()!
        super.init(frame: frame)
        if type == .circle {
            self.layer.cornerRadius = figureSize / 2
            self.layer.masksToBounds = true
        }
        self.backgroundColor = .getRandomColor()
    }
    
    override public var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return type == .circle ? .ellipse : .rectangle
    }
}
