//
//  ViewController.swift
//  MotionCube
//
//  Created by Steve Vovchyna on 18.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit

class Figure: UIView {
    var type : String?
    let possibleShapes = ["circle", "square"]
    var figureSize: CGFloat = 100.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init() was not implemented")
    }
    
    init(location: CGPoint) {
        let frame = CGRect(x: location.x - (figureSize / 2), y: location.y, width: figureSize, height: figureSize)
        self.type = possibleShapes.randomElement()!
        super.init(frame: frame)
        if self.type == "circle" {
            self.layer.cornerRadius = figureSize / 2
            self.layer.masksToBounds = true
//            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        self.backgroundColor = .getRandomColor()
    }
}

extension UIColor {
    static func getRandomColor() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
    }
}


class ViewController: UIViewController {
    
    var animator = UIDynamicAnimator()
    let gravityBehavior = UIGravityBehavior()
    var elasticityBehavior = UIDynamicItemBehavior(items: [])
    var collisionBehavior = UICollisionBehavior(items: [])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        
        animator.addBehavior(gravityBehavior)
        animator.addBehavior(collisionBehavior)
        animator.addBehavior(elasticityBehavior)
        
        elasticityBehavior.elasticity = 0.1
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 0.7)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
    }

    @IBAction func touchRecognizer(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        let figure = Figure(location: location)
        
        let move = UIPanGestureRecognizer(target: self, action: #selector(movementHandler(recognizer:)))
        let zoom = UIPinchGestureRecognizer(target: self, action: #selector(zoomHandler(recognizer:)))
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotationHandler(recognizer:)))
        
        view.addSubview(figure)
        
        gravityBehavior.addItem(figure)
        collisionBehavior.addItem(figure)
        elasticityBehavior.addItem(figure)
        
        figure.addGestureRecognizer(move)
        figure.addGestureRecognizer(zoom)
        figure.addGestureRecognizer(rotate)
    }
    
    @objc private func movementHandler(recognizer: UIPanGestureRecognizer) {
        guard let figure = recognizer.view else { return }
        switch recognizer.state {
            case .began:
                gravityBehavior.removeItem(figure)
                collisionBehavior.removeItem(figure)
                elasticityBehavior.removeItem(figure)
            case .changed:
                figure.center = recognizer.location(in: figure.superview)
                animator.updateItem(usingCurrentState: figure)
            case .ended:
                gravityBehavior.addItem(figure)
                collisionBehavior.addItem(figure)
                elasticityBehavior.addItem(figure)
        default:
            break
        }
    }
    
    @objc private func zoomHandler(recognizer: UIPinchGestureRecognizer) {
        guard let figure = recognizer.view else { return }
        switch recognizer.state {
        case .began:
            gravityBehavior.removeItem(figure)
            collisionBehavior.removeItem(figure)
            elasticityBehavior.removeItem(figure)
        case .changed:
            guard figure.layer.bounds.size.width + 20 < self.view.frame.width,
                    figure.layer.bounds.size.height + 20 < self.view.frame.height else { return }
            figure.layer.bounds.size.height *= recognizer.scale
            figure.layer.bounds.size.width *= recognizer.scale
            guard let shape = figure as? Figure else {
                return
            }
            if shape.type == "circle" {
                shape.layer.cornerRadius *= recognizer.scale
            }
            recognizer.scale = 1
        case .ended:
            gravityBehavior.addItem(figure)
            collisionBehavior.addItem(figure)
            elasticityBehavior.addItem(figure)
        default:
            break
        }
    }
    
    @objc private func rotationHandler(recognizer: UIRotationGestureRecognizer) {
        guard let figure = recognizer.view else { return }
        switch recognizer.state {
        case .began:
            gravityBehavior.removeItem(figure)
            collisionBehavior.removeItem(figure)
            elasticityBehavior.removeItem(figure)
        case .changed:
            figure.transform = figure.transform.rotated(by: recognizer.rotation)
            animator.updateItem(usingCurrentState: figure)
            recognizer.rotation = 0
        case .ended:
            gravityBehavior.addItem(figure)
            collisionBehavior.addItem(figure)
            elasticityBehavior.addItem(figure)
        default:
            break
        }
    }
}

