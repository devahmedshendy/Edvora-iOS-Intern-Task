//
//  CGFloat+Extension.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

extension CGFloat {
    
    private static var baseCornerRadius: CGFloat {
        UIDevice.iPad ? 12 : 8
    }
    
    // MARK: - Screen
    
    static let screenTopPadding: CGFloat = 20
    static let screenBottomPadding: CGFloat = -20
    static let screenLeadingPadding: CGFloat = 20
    static let screenTrailingPadding: CGFloat = -20
    
    // MARK: - ProductCell
    
    static var productCellCornerRadius: CGFloat {
        UIDevice.iPad ? 14 : 10
    }
    
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
    static var productNameLeadingPadding: CGFloat {
        UIDevice.iPad ? 20 : 15
    }
    static let brandNameTopPadding: CGFloat  = 5
    static let priceTopPadding: CGFloat = 7
    static let dateTopPadding: CGFloat = 10
    static var locationTopPadding: CGFloat {
        UIDevice.iPad ? 15 : 10
    }
    static let descriptionTopPadding: CGFloat = 10
    static let productCellSubviewsSpacing: CGFloat = 5
    
    // MARK: - ProductsHeaderView
    
    static let productsHeaderSeparatorTopPadding: CGFloat = 10
    
    
    static let productCollectionLeadingInset: CGFloat = 20
    static let productCollectionTopInset: CGFloat = 20
    static let productCollectionBottomInset: CGFloat = 30
    
    // MARK: - HomeRootView
    
    static let homeCollectionViewTopPadding: CGFloat = 25
    
    // MARK: - FiltersBarView
    
    static var clearFiltersButtonLeadingPadding: CGFloat {
        UIDevice.iPad ? 20 : 15
    }
    
    // MARK: - FiltersPopupView
    
    static let filterPopupCornerRadius: CGFloat = 15
    
    static var filtersPopupContentLeadingPadding: CGFloat {
        UIDevice.iPad ? 35 : 30
    }
    static var filtersPopupContentTrailingPadding: CGFloat {
        UIDevice.iPad ? -35 : -30
    }
    static var filtersPopupContentTopPadding: CGFloat  {
        UIDevice.iPad ? 35 : 30
    }
    static var filtersPopupContentBottomPadding: CGFloat  {
        UIDevice.iPad ? -35 : -30
    }
    static var filtersPopupHeaderSeparatorTopPadding: CGFloat {
        UIDevice.iPad ? 15 : 10
    }
    static var filtersPopupButtonStackSpacing: CGFloat {
        UIDevice.iPad ? 17 : 12
    }
    static var filtersPopupButtonStackTopPadding: CGFloat {
        UIDevice.iPad ? 40 : 35
    }
    static var filtersPopupApplyButtonBottomPadding: CGFloat {
        UIDevice.iPad ? 25 : 20
    }
    static var filtersPopupSelectViewLeadingPadding: CGFloat = -25
    static var filtersPopupSelectViewTrailingPadding: CGFloat = 25
    static var filtersPopupSelectViewTopPadding: CGFloat = -25
    static var filtersPopupSelectViewBottomPadding: CGFloat = 25
    
    // MARK: - SelectButton
    
    static var selectButtonCornerRadius: CGFloat {
        baseCornerRadius
    }
    
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
    static var selectButtonTitleTrailingPadding: CGFloat {
        UIDevice.iPad ? 9 : 5
    }
    
    // MARK: - SpinnerView
    
    static var spinnerViewCornerRadius: CGFloat {
        baseCornerRadius
    }
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
    
    // MARK: - SelectView
    
    static let selectViewCornerRadius: CGFloat = 15
    
    static var selectViewContentLeadingPadding: CGFloat {
        UIDevice.iPad ? 24 : 20
    }
    static var selectContentTrailingPadding: CGFloat {
        UIDevice.iPad ? -24 : -20
    }
    static var selectViewContentTopPadding: CGFloat {
        UIDevice.iPad ? 19 : 15
    }
    static var selectViewContentBottomPadding: CGFloat {
        UIDevice.iPad ? -19 : -15
    }
    static var selectViewSeparatorLeadingPadding: CGFloat {
        UIDevice.iPad ? 17 : 15
    }
    static var selectViewSeparatorTrailingPadding: CGFloat {
        UIDevice.iPad ? -17 : -15
    }
    static var selectViewSeparatorTopPadding: CGFloat {
        UIDevice.iPad ? 7 : 5
    }
    static var selectViewTableTopPadding: CGFloat {
        UIDevice.iPad ? 14 : 10
    }
    
    // MARK: - ActionButton
    
    static var actionButtonCornerRadius: CGFloat {
        baseCornerRadius
    }
}
