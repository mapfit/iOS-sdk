//
//  ZoomButtonView.swift
//  iOS.SDK
//
//  Created by Zain N. on 1/30/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import UIKit

internal protocol MFTZoomButtonsViewDelegate : class {
    func plusButtonTapped(_ sender : AnyObject)
    func minusButtonTapped(_ sender : AnyObject)
}

internal class MFTZoomButtonsView: UIView {
    
    var plusButton = ZoomButton()
    var minusButton = ZoomButton()
    var backgroundImage = UIImageView()
    
    weak var delegate: MFTZoomButtonsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createZoomButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createZoomButtons(){
        self.addSubview(backgroundImage)
        self.addSubview(plusButton)
        self.addSubview(minusButton)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.minusButton.translatesAutoresizingMaskIntoConstraints = false
        self.plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.backgroundImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.backgroundImage.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.backgroundImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        

        self.plusButton.centerXAnchor.constraint(equalTo: self.backgroundImage.centerXAnchor).isActive = true
        self.plusButton.topAnchor.constraint(equalTo: self.backgroundImage.topAnchor, constant: 17.6).isActive = true
        self.plusButton.heightAnchor.constraint(equalToConstant: 17.3).isActive = true
        self.plusButton.widthAnchor.constraint(equalToConstant: 17.3).isActive = true
        self.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        self.minusButton.centerXAnchor.constraint(equalTo: self.backgroundImage.centerXAnchor).isActive = true
        self.minusButton.topAnchor.constraint(equalTo: self.plusButton.bottomAnchor, constant: 29).isActive = true
        self.minusButton.heightAnchor.constraint(equalToConstant: 2.6).isActive = true
        self.minusButton.widthAnchor.constraint(equalToConstant: 17.3).isActive = true
        self.minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .allTouchEvents)
        self.minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .allTouchEvents)

        self.backgroundImage.image = UIImage(named: "ZoomBacking_iOS.png", in: Bundle.houseStylesBundle(), compatibleWith: nil)
        self.plusButton.setImage(UIImage(named: "zoomIn.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        self.minusButton.setImage(UIImage(named: "zoomOut.png", in: Bundle.houseStylesBundle(), compatibleWith: nil), for: .normal)
        
        //self.plusButton.imageView?.contentMode = .scaleAspectFit
        //self.minusButton.imageView?.contentMode = .scaleAspectFit
 
    }
    
 @objc func plusButtonTapped(_ sender: AnyObject) {
        // some way to transition to camera
        if let delegate = self.delegate {
            delegate.plusButtonTapped(sender)
        } else {
        
        }
    }
    
  @objc  func minusButtonTapped(_ sender: AnyObject) {
        // some way to transition to camera
        if let delegate = self.delegate {
            delegate.minusButtonTapped(sender)
        } else {
            
        }
    }
}


internal class ZoomButton: UIButton {
    var padding = CGFloat(0) // default value
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let padding = CGFloat(10)
        let extendedBounds = bounds.insetBy(dx: -padding, dy: -padding)
        return extendedBounds.contains(point)
    }
}


