//
//  CGFloat+Extension.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

extension CGFloat {
    static let cornerRadius: CGFloat = 10
    static let filterViewCornerRadius: CGFloat = 15
    
    static let screenTopPadding: CGFloat = 20
    static let screenBottomPadding: CGFloat = -20
    static let screenLeadingPadding: CGFloat = 20
    static let screenTrailingPadding: CGFloat = -20
    
    static var productCellLeadingPadding: CGFloat {
        UIDevice.iPad ? 25 : 20
    }
    static var productCellTrailingPadding: CGFloat {
        UIDevice.iPad ? -25 : -20
    }
    static var productCellTopPadding: CGFloat {
        UIDevice.iPad ? 25 : 20
    }
    static var productCellBottomPadding: CGFloat {
        UIDevice.iPad ? -25 : -20
    }
    static let productCellSubviewsSpacing: CGFloat = 5
    
    
    static let productCollectionLeadingInset: CGFloat = 20
    static let productCollectionTopInset: CGFloat = 20
    static let productCollectionBottomInset: CGFloat = 30
    
    static let filtersViewContentLeadingPadding: CGFloat = 30
    static let filtersViewContentTrailingPadding: CGFloat = -30
    static let filtersViewContentTopPadding: CGFloat = 30
    static let filtersViewContentBottomPadding: CGFloat = -30
    
    // MARK: - SelectButton
    
    static var selectButtonLeadingPadding: CGFloat {
        UIDevice.iPad ? 16 : 12
    }
    static var selectButtonTrailingPadding: CGFloat {
        UIDevice.iPad ? -16 : -12
    }
    static var selectButtonTopPadding: CGFloat {
        UIDevice.iPad ? 12 : 8
    }
    static var selectButtonBottomPadding: CGFloat {
        UIDevice.iPad ? -12 : -8
    }
    
    // MARK: - SpinnerView
    
    static var spinnerSide: CGFloat {
        UIDevice.iPad ? 1.7 : 1.5
    }
    static var spinnerViewLeadingPadding: CGFloat {
        UIDevice.iPad ? 24 : 20
    }
    static var spinnerViewTrailingPadding: CGFloat {
        UIDevice.iPad ? -24 : -20
    }
    static var spinnerViewTopPadding: CGFloat {
        UIDevice.iPad ? 19 : 15
    }
    static var spinnerViewBottomPadding: CGFloat {
        UIDevice.iPad ? -19 : -15
    }
    static var spinnerViewContentSpacing: CGFloat {
        UIDevice.iPad ? 24 : 20
    }
}
