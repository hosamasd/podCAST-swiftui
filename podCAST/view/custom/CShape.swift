//
//  CShape.swift
//  Gradient Picker
//
//  Created by hosam on 1/18/21.
//

import SwiftUI


struct CShape : Shape {
    
    var corners:UIRectCorner
    var width:CGFloat = 55
    
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners:corners , cornerRadii: CGSize(width: width, height: width))
        
        return Path(path.cgPath)
    }
}
