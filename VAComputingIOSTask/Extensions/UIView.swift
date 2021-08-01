//
//  UIView.swift
//  VAComputingIOSTask
//
//  Created by iMac on 31/07/2021.
//

import UIKit
extension UIView {

    

    func addShadowForAllSides() {
     //   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2009310788)
        // *** Set masks bounds to NO to display shadow visible ***
        layer.masksToBounds = false
        // *** Set light gray color as shown in sample ***
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2009310788)
        // *** *** Use following to add Shadow top, left ***
      //  layer.shadowOffset = CGSize(width: -5.0, height: -5.0)

        // *** Use following to add Shadow bottom, right ***
        //self.avatarImageView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);

        // *** Use following to add Shadow top, left, bottom, right ***
        layer.shadowOffset = CGSize.zero
         layer.shadowRadius = 5.0

        // *** Set shadowOpacity to full (1) ***
      layer.shadowOpacity = 0.5
    }
    
}

extension UIView {
    
@IBInspectable var isCircled: Bool {
    get {
        return false
    }
    set {
        if newValue {
            self.cornerRadius = self.bounds.height / 2
        }
    }
}

}


extension UIImageView {
    func circleImage() {
        self.layer.cornerRadius = (self.frame.size.width) / 2;
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
    }
}



@IBDesignable
extension UIView
{
    
    @IBInspectable
    public var cornerRadius: CGFloat
    {
        set (radius) {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = radius > 0
        }
        
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.init(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    
    
    // This function is used to round top Corner For UIView
    func roundTopCorner(cornerRadius: Double) {
           let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
           let maskLayer = CAShapeLayer()
           maskLayer.frame = self.bounds
           maskLayer.path = path.cgPath
           self.layer.mask = maskLayer
       }
    
    func roundBottomCorner(cornerRadius: Double) {
              let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
              let maskLayer = CAShapeLayer()
              maskLayer.frame = self.bounds
              maskLayer.path = path.cgPath
              self.layer.mask = maskLayer
          }
    
    func roundTopBottomRight(cornerRadius: Double) {
           let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
           let maskLayer = CAShapeLayer()
           maskLayer.frame = self.bounds
           maskLayer.path = path.cgPath
           self.layer.mask = maskLayer
       }
    
}

