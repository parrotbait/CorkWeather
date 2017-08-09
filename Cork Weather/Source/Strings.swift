//
//  Strings.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct Strings {
    public static func get(_ key : String) -> String {
        let ret = Bundle.main.localizedString(forKey: key, value: "", table: nil);
        if (ret.isEmpty) {
            return key;
        }
        return ret
    }
}
