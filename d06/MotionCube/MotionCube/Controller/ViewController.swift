//
//  ViewController.swift
//  MotionCube
//
//  Created by Steve Vovchyna on 18.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    
    var animator = UIDynamicAnimator()
    let gravityBehavior = UIGravityBehavior()
    var elasticityBehavior = UIDynamicItemBehavior(items: [])
    var collisionBehavior = UICollisionBehavior(items: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        setupAnimator(animator)
        setupMotion()
    }

    @IBAction func touchRecognizer(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        let figure = Figure(location: location)
        
        figure.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movementHandler(recognizer:))))
        figure.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(zoomHandler(recognizer:))))
        figure.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotationHandler(recognizer:))))
        view.addSubview(figure)
        animationsOff(toggle: false, target: figure)
    }
}

extension ViewController {
    @objc private func movementHandler(recognizer: UIPanGestureRecognizer) {
        guard let figure = recognizer.view else { return }
        switch recognizer.state {
            case .began:
                gravityBehavior.removeItem(figure)
            case .changed:
                figure.center = recognizer.location(in: figure.superview)
                animator.updateItem(usingCurrentState: figure)
            case .ended:
                gravityBehavior.addItem(figure)
            default:
                break
        }
    }
    
    @objc private func zoomHandler(recognizer: UIPinchGestureRecognizer) {
        guard let figure = recognizer.view else { return }
        switch recognizer.state {
            case .began:
                animationsOff(toggle: true, target: figure)
            case .changed:
                if (figure.layer.bounds.size.width * recognizer.scale) + 40 < self.view.frame.width  {
                    figure.layer.bounds.size.height *= recognizer.scale
                    figure.layer.bounds.size.width *= recognizer.scale
                    guard let shape = figure as? Figure else { return }
                    if shape.type == .circle { shape.layer.cornerRadius *= recognizer.scale }
                }
                recognizer.scale = 1
            case .ended:
                animationsOff(toggle: false, target: figure)
            default:
                break
        }
    }
    
    @objc private func rotationHandler(recognizer: UIRotationGestureRecognizer) {
        guard let figure = recognizer.view else { return }
        switch recognizer.state {
        case .began:
            animationsOff(toggle: true, target: figure)
        case .changed:
            figure.transform = figure.transform.rotated(by: recognizer.rotation)
            animator.updateItem(usingCurrentState: figure)
            recognizer.rotation = 0
        case .ended:
            animationsOff(toggle: false, target: figure)
        default:
            break
        }
    }
}

extension ViewController {
    private func setupMotion() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                self.gravityBehavior.gravityDirection = CGVector(dx: (data?.acceleration.x)!, dy: -1 * (data?.acceleration.y)!)
            }
        }
    }
    
    private func setupAnimator(_ animator: UIDynamicAnimator) {
        animator.addBehavior(gravityBehavior)
        animator.addBehavior(collisionBehavior)
        animator.addBehavior(elasticityBehavior)
        elasticityBehavior.elasticity = 0.5
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 0.7)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
    }
    
    private func animationsOff(toggle: Bool, target: UIView) {
        toggle ? gravityBehavior.removeItem(target) : gravityBehavior.addItem(target)
        toggle ? collisionBehavior.removeItem(target) : collisionBehavior.addItem(target)
        toggle ? elasticityBehavior.removeItem(target) : elasticityBehavior.addItem(target)
    }
}

