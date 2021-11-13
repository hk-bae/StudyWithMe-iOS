//
//  UIColor+Service.swift
//  StudyWithMe
//
//  Created by 배한결 on 2021/11/02.
//

import UIKit

extension UIColor {
    enum Service {
        case mainDarkBlue
        case mainLightBlue
        case yellow
        case shadowGray
        case borderGray
        case gray
        
        var value : UIColor {
            switch self {
            case .yellow :
                return UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0/255.0, alpha: 1)
            case .mainDarkBlue :
                return UIColor(red: 0, green: 25.0/255.0, blue: 65.0/255.0, alpha: 1)
            case .mainLightBlue :
                return UIColor(red: 0, green: 0, blue: 90.0/255.0,alpha: 1)
            case .shadowGray :
                return UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 0.3)
            case .gray :
                return UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
            case .borderGray :
                return UIColor(red: 104.0/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1)
            }
        }
        
    }
}
