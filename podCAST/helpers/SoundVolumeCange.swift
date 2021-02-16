//
//  SoundVolumeCange.swift
//  podCAST
//
//  Created by hosam on 2/15/21.
//

import SwiftUI
import MediaPlayer

//Update system volume
extension MPVolumeView {
    
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}

extension CMTime {
    
    func toStringDisplay() ->String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let second = totalSeconds %  60
        let mintue = totalSeconds % (60 * 60) / 60
        let hours = totalSeconds / 60 / 60
        
        let displayString = String(format: "%02d:%02d:%02d", hours,mintue,second)
        
        return displayString
    }
    
    var timeString: String {
           let sInt = Int(seconds)
           let s: Int = sInt % 60
           let m: Int = (sInt / 60) % 60
           let h: Int = sInt / 3600
           return String(format: "%02d:%02d:%02d", h, m, s)
       }
       
       var timeFromNowString: String {
           let d = Date(timeIntervalSinceNow: seconds)
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "mm:ss"
           return dateFormatter.string(from: d)
       }
}
