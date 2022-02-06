//
//  UIFont+Extension.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

extension UIFont {
    
    // MARK: - ProductsHeaderView
    
    static var productsHeaderFont: UIFont {
        regularRoboto(ofSize: UIDevice.iPad ? 24 : 20)
    }
    
    // MARK: - ProductCell
    
    static var productNameFont: UIFont {
        systemFont(ofSize: UIDevice.iPad ? 19 : 15, weight: .regular)
    }
    
    static var brandNameFont: UIFont {
        systemFont(ofSize: UIDevice.iPad ? 17 : 13, weight: .regular)
    }
    
    static var priceFont: UIFont {
        systemFont(ofSize: UIDevice.iPad ? 17 : 13, weight: .medium)
    }
    
    static var dateFont: UIFont {
        systemFont(ofSize: UIDevice.iPad ? 17 : 13, weight: .regular)
    }
    
    static var locationFont: UIFont {
        systemFont(ofSize: UIDevice.iPad ? 17 : 13, weight: .regular)
    }
    
    static var descriptionFont: UIFont {
        systemFont(ofSize: UIDevice.iPad ? 17 : 13, weight: .regular)
    }
    
    // MARK: - FiltersPopUpView
    
    static var filtersPopupHeaderFont: UIFont {
        systemFont(ofSize: UIDevice.iPad ? 24 : 20, weight: .regular)
    }
    
    // MARK: - SelectViewCell
    
    static var selectViewCellTextFont: UIFont {
        systemFont(ofSize: UIDevice.iPad ? 20 : 16, weight: .regular)
    }
    
    // MARK: - SelectButton
    
    static var selectButtonTitleFont: UIFont {
        regularRoboto(ofSize: UIDevice.iPad ? 20 : 16)
    }
    
    static func regularRoboto(ofSize size: CGFloat) -> UIFont {
        UIFont(name: "Roboto-Regular", size: size)!
    }
    
    // MARK: - TextButton
    
    static var textButtonFont: UIFont {
        systemFont(ofSize: UIDevice.iPad ? 19 : 15, weight: .regular)
    }
    
    // MARK: - ActionButton
    
    static var actionButtonTitleFont: UIFont {
        regularRoboto(ofSize: UIDevice.iPad ? 20 : 16)
    }
    
    // MARK: - FiltersBarView
    
    static var filtersBarClearButtonFont: UIFont {
        regularRoboto(ofSize: UIDevice.iPad ? 20 : 16)
    }
    
    // MARK: - SpinnerView
    
    static var spinnerTitleFont: UIFont {
        systemFont(ofSize: UIDevice.iPad ? 21 : 17, weight: .medium)
    }
}
