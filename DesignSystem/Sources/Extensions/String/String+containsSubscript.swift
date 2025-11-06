//
//  String+containsSubscript.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 10/03/2025.
//

extension String {

    var containsSubscript: Bool {
        let superscriptRange = 0x2080...0x209F
        return self.unicodeScalars.contains { scalar in
            superscriptRange.contains(Int(scalar.value))
        }
    }
}
