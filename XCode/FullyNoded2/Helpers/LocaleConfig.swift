//
//  LocaleConfig.swift
//  FullyNoded2
//
//  Created by Gautham Ganesh Elango on 21/7/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import Foundation
import UIKit

class LocaleConfig {
    
    let localeToCurrency = [
        "US": "USD",
        "AU": "AUD",
        "CA": "CAD",
    ]
    let currencyList = ["USD", "AUD", "CAD"]
    var locale = "USD"
    var savedLocale = UserDefaults.standard.string(forKey: "currentLocale") ?? "USD"
    
    func getLocale() -> Void {
        locale = localeToCurrency[Locale.current.regionCode ?? "US"]!
        print(locale)
        if UserDefaults.standard.string(forKey: "currentLocale") == nil {
            UserDefaults.standard.set(locale, forKey: "currentLocale")
            savedLocale = locale
        }
    }
    
    func changeLocale(newLocale: String) -> Void {
        UserDefaults.standard.set(newLocale, forKey: "currentLocale")
        savedLocale = newLocale
    }
}
