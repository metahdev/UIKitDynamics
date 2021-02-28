//
//  PhysicsViewController.swift
//  UIKitDynamics
//
//  Created by iosdev.kz on 20.02.2021.
//

import UIKit

class PhysicsViewController: UIViewController {
    // MARK:- Properties
    private lazy var backboard: UIView = {
        let v = UIView()
        v.commonView(color: .red)
        v.layer.cornerRadius = 5
        return v
    }()
    private lazy var connectingPart: UIView = {
        let v = UIView()
        v.commonView(color: .lightGray)
        return v
    }()
    private lazy var hoopBeginning: UIView = {
        let v = UIView()
        v.commonView(color: .lightGray)
        return v
    }()
    private lazy var hoopCenter: UIView = {
        let v = UIView()
        v.commonView(color: .red)
        v.layer.zPosition = 1
        return v
    }()
    private lazy var hoopEnd: UIView = {
        let v = UIView()
        v.commonView(color: .lightGray)
        return v
    }()
    private lazy var ball: CircleView = {
        let v = CircleView()
        v.commonView(color: .clear)
        v.image = UIImage(named: "ball")
        v.clipsToBounds = true
        v.layer.cornerRadius = 50
        return v
    }()
    private lazy var touchView: UIView = {
        let v = UIView()
        v.commonView(color: .darkGray)
        v.layer.cornerRadius = 10
        v.frame.size = CGSize(width: 20, height: 20)
        return v
    }()
    
    private var animator: UIDynamicAnimator!
    private var currentLocation: CGPoint!
    private var attachment: UIAttachmentBehavior!
    private var lastInteraction: String?
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubviews()
        setFrames()
        setupAnimator()
    }
    
    private func addSubviews() {
        view.addSubview(backboard)
        view.addSubview(connectingPart)
        view.addSubview(hoopBeginning)
        view.addSubview(hoopCenter)
        view.addSubview(hoopEnd)
        view.addSubview(ball)
    }
    
    private func setFrames() {
        // Setting the frames manually
        backboard.frame = CGRect(x: 0, y: 100, width: 10, height: 250)
        connectingPart.frame = CGRect(x: 10, y: 302, width: 5, height: 2)
        hoopBeginning.frame = CGRect(x: 15, y: 300, width: 2, height: 5)
        hoopCenter.frame = CGRect(x: 17, y: 300, width: 130, height: 5)
        hoopEnd.frame = CGRect(x: 147, y: 300, width: 2, height: 5)
        ball.frame = CGRect(x: 200, y: -10, width: 100, height: 100)
    }
    
    private func setupAnimator() {
        animator = UIDynamicAnimator(referenceView: self.view)
        
        setGravity()
        setCollision()
        setBehavior()
    }
    
    private func setGravity() {
        let gravity = UIGravityBehavior(items: [ball])
        animator.addBehavior(gravity)
    }
    
    private func setCollision() {
        let collision = UICollisionBehavior(items: [ball])
 
        collision.addBoundary(withIdentifier: "back" as NSCopying, for: UIBezierPath(rect: backboard.frame))
        collision.addBoundary(withIdentifier: "connecting" as NSCopying, for: UIBezierPath(rect: connectingPart.frame))
        collision.addBoundary(withIdentifier: "start" as NSCopying, for: UIBezierPath(rect: hoopBeginning.frame))
        collision.addBoundary(withIdentifier: "end" as NSCopying, for: UIBezierPath(rect: hoopEnd.frame))
        
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        animator.addBehavior(collision)
    }

    private func setBehavior() {
        let behavior = UIDynamicItemBehavior(items: [ball])
        behavior.elasticity = 0.9
        
        animator.addBehavior(behavior)
    }
    
    
    // MARK:- Attachment
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let theTouch = touches.first {
            // assigning the attachment point of the red view to the touch location, which makes it hang at a certain distance
            // offset makes the attraction more realistic
            currentLocation = theTouch.location(in: self.view)
            let offset = UIOffset(horizontal: 15, vertical: 15)
            attachment = UIAttachmentBehavior(item: ball, offsetFromCenter: offset, attachedToAnchor: currentLocation)
            attachment.frequency = 1.5
            
            animator.addBehavior(attachment)
            
            view.addSubview(touchView)
            touchView.center = currentLocation
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let theTouch = touches.first {
            currentLocation = theTouch.location(in: self.view)
            attachment.anchorPoint = currentLocation
            touchView.center = currentLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        animator.removeBehavior(attachment)
        touchView.removeFromSuperview()
    }
}


extension PhysicsViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        guard let collision = identifier as? String else {
            return
        }
        print("Contact occurred - \(collision)")
    }
}
