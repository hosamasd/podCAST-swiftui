//
//  BlurView.swift
//  Music Apple
//
//  Created by hosam on 11/17/20.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
        
    }
}
