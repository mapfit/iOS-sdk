//
//  MFTPlaceInfoView.swift
//  iOS.SDK
//
//  Created by Zain N. on 1/31/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import UIKit
import GLKit

internal class MFTPlaceInfoView:  UIView {
    
    /**
     `MFTPlaceInfoView` This is the default view for the place marker of the Mapfit SDK.
     */

    internal var backgroundImageView = UIImageView()
    internal var title = UILabel()
    internal var subtitle1 = UILabel()
    internal var subtitle2 = UILabel()
    lazy var labelStackView: UIStackView = UIStackView()
    
    var marker: MFTMarker? {
        didSet {
            self.title.text = marker?.title
            self.subtitle1.text = marker?.subtitle1
            self.subtitle2.text = marker?.subtitle2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        createMFTPlaceInfoView()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   internal func createMFTPlaceInfoView(){
         self.addSubview(backgroundImageView)
         self.addSubview(labelStackView)
        
        //self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.labelStackView.translatesAutoresizingMaskIntoConstraints = false
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.subtitle1.translatesAutoresizingMaskIntoConstraints = false
        self.subtitle2.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.backgroundImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.backgroundImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.backgroundImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        backgroundImageView.image = UIImage(named: "CardBacking.png", in: Bundle.houseStylesBundle(), compatibleWith: nil)
        self.backgroundImageView.contentMode = .scaleAspectFill
        
        self.labelStackView.leadingAnchor.constraint(equalTo: self.backgroundImageView.leadingAnchor, constant: 15.3).isActive = true
        self.labelStackView.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor, constant: -37.3).isActive = true
        self.labelStackView.topAnchor.constraint(equalTo: self.backgroundImageView.topAnchor, constant: 17.6).isActive = true
        self.labelStackView.trailingAnchor.constraint(equalTo: self.backgroundImageView.trailingAnchor, constant: -22.6).isActive = true
        
        self.labelStackView.addArrangedSubview(title)
        self.labelStackView.addArrangedSubview(subtitle1)
        self.labelStackView.addArrangedSubview(subtitle2)
        
        self.title.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        self.subtitle1.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        self.subtitle2.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)

        self.title.textColor = .darkGray
        self.subtitle1.textColor = .darkGray
        self.subtitle2.textColor = .darkGray
        self.labelStackView.axis = .vertical
        self.labelStackView.spacing = 4.8

    }
    
    

    
}
