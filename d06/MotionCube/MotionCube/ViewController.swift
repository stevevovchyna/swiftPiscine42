//
//  ViewController.swift
//  MotionCube
//
//  Created by Steve Vovchyna on 18.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class Draw : UIView {
    
    let shapes = ["rectangle", "circle"]
    let colors : [UIColor] = [.red, .orange, .yellow, .green, .blue, .cyan, .black]
    let size : CGFloat = 100.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        let color = colors.randomElement()!
        let shape = shapes.randomElement()!
        let size : CGFloat = 100.0

        switch shape {
        case "rectangle":
            addSquare(rect: rect, color: color, size: size)
        case "circle":
            addCircle(rect: rect, color: color)
        default:
            return
        }
    }
    
    private func addCircle(rect : CGRect, color : UIColor) {
        let desiredLineWidth : CGFloat = 4
        let hw : CGFloat = desiredLineWidth / 2

        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: hw, dy: hw))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        layer.addSublayer(shapeLayer)
    }
    
    private func addSquare(rect : CGRect, color : UIColor, size : CGFloat) {
        let p1 = self.bounds.origin
        let p2 = CGPoint(x: p1.x + size, y: p1.y)
        let p3 = CGPoint(x: p2.x, y: p2.y + size)
        let p4 = CGPoint(x: p1.x, y: p1.y + size)

        // create the path
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p4)
        path.close()

        // fill the path
        color.set()
        path.fill()
    }
}


class ViewController: UIViewController {

    @IBOutlet var gestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        
    }
    
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        addShape()
    }
    
    func addShape() {
        let x = gestureRecognizer.location(in: self.view).x - 50.0
        let y = gestureRecognizer.location(in: self.view).y - 50.0
        let frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: 100.0, height: 100.0))
        let shape = Draw(frame: frame)
        self.view.addSubview(shape)
    }
    
}

