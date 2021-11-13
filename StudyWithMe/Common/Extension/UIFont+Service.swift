//
//  UIFont+Service.swift
//  StudyWithMe
//
//  Created by 배한결 on 2021/11/02.
//

import UIKit
extension UIFont {
    enum Service {
        case inter_bold(_ size:CGFloat)
        case notoSans_bold(_ size:CGFloat)
        case notoSans_regular(_size:CGFloat)
        
        var value: UIFont {
            switch self {
            case .inter_bold(let size) : return UIFont(name: self.fontName, size: size) ??
                UIFont.systemFont(ofSize: size)
            case .notoSans_bold(let size): return UIFont(name: self.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
            case .notoSans_regular(let size): return UIFont(name: self.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
            }
        }
        
        var fontName: String {
            switch self {
            case .inter_bold : return "Inter-Bold"
            case .notoSans_bold: return "NotoSansCJkr-Bold"
            case .notoSans_regular: return "NotoSansCJkr-Regular"
            }
        }
    }
}
