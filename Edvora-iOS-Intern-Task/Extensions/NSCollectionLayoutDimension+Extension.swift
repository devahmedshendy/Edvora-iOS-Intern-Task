//
//  NSCollectionLayoutDimension+Extension.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/6/22.
//

import UIKit

extension NSCollectionLayoutDimension {
    
    // MARK: - ProductCell
    
    static var productCellGroupWidthDimention: NSCollectionLayoutDimension {
        .fractionalWidth(UIDevice.iPad ? 0.40 : 0.65)
    }
    
}
