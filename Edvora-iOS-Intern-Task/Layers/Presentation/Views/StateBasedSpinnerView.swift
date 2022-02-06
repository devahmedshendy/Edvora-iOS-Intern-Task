//
//  StateBasedSpinnerView.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/6/22.
//

enum SpinnerState: String {
    case isPreparing = "Preparing..."
    case isApplyingFilters = "Applying Filters..."
}

final class StateBasedSpinnerView: SpinnerView {
    
    // MARK: - Helpers
    
    func updateVisibility(_ isVisible: Bool, forState state: SpinnerState) {
        title = state.rawValue
        isShown = isVisible
    }
    
}
