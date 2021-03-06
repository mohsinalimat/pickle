//
//  This source file is part of the carousell/pickle open source project
//
//  Copyright © 2017 Carousell and the project authors
//  Licensed under Apache License v2.0
//
//  See https://github.com/carousell/pickle/blob/master/LICENSE for license information
//  See https://github.com/carousell/pickle/graphs/contributors for the list of project authors
//

import UIKit

internal extension UIFont {

    internal static var forCameraButton: UIFont {
        return UIFont.systemSemiBoldFont(ofSize: 10)
    }

    internal static var forHintLabel: UIFont {
        if let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .caption2).withSymbolicTraits(.traitBold) {
            return UIFont(descriptor: descriptor, size: 0)
        } else {
            return UIFont.preferredFont(forTextStyle: .caption2)
        }
    }

    internal static var forTagLabel: UIFont {
        return UIFont.systemSemiBoldFont(ofSize: 16)
    }

    private static func systemSemiBoldFont(ofSize fontSize: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
        } else {
            return UIFont.systemFont(ofSize: fontSize)
        }
    }

}
