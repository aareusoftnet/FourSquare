//
//  StringExtensions.swift
//  FourSquare
//
//  Created by Vipul Patel on 09/01/22.
//

import UIKit

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var isEmpty: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).count == 0
    }
}
