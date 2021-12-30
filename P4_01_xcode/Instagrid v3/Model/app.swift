//
//  shareImage.swift
//  Instagrid
//
//  Created by Guillaume Bourlart on 26/09/2021.
//

import Foundation
import UIKit

class App {
    
    let appTitle = "Instagrid"  //App title
    
    // return the label depending of the orientation
    var swipeLabel: String {
        if UIDevice.current.orientation.isLandscape == true {
            return "Swipe left to share"
            } else {
                return "Swipe up to share"
            }
    }
    // differents model state
    enum Grid: Int {
        case largeLittle = 1
        case littleLarge = 2
        case fullLittle = 3
        
    }
    // current model state
    var grid = Grid.littleLarge
    
    
   
}
