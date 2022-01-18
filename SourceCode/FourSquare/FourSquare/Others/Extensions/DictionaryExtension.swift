//
//  DictionaryExtension.swift
//  FourSquare
//
//  Created by Vipul Patel on 17/01/22.
//

import Foundation

//MARK: -
extension Dictionary {
    
    mutating func merge(_ other: Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

//MARK: -
extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func dict2json() -> String {
        return json
    }
}

//MARK: -
extension NSDictionary {
    
    func getDoubleValue(forKey: String) -> Double {
        if let any: Any = value(forKey: forKey) {
            if let number = any as? NSNumber {
                return number.doubleValue
            }else if let string = any as? NSString {
                return string.doubleValue
            }
        }
        return 0.0
    }
    
    func getFloatValue(forKey: String) -> Float {
        if let any: Any = value(forKey: forKey) {
            if let number = any as? NSNumber {
                return number.floatValue
            }else if let string = any as? NSString {
                return string.floatValue
            }
        }
        return 0.0
    }
    
    func getUIntValue(forKey: String) -> UInt {
        if let any: Any = value(forKey: forKey) {
            if let number = any as? NSNumber {
                return number.uintValue
            }else if let string = any as? NSString {
                return UInt(string.integerValue)
            }
        }
        return 0
    }

    func getIntValue(forKey: String) -> Int {
        if let any: Any = value(forKey: forKey) {
            if let number = any as? NSNumber {
                return number.intValue
            }else if let string = any as? NSString {
                return string.integerValue
            }
        }
        return 0
    }
    
    func getInt64Value(forKey: String) -> Int64 {
        if let any: Any = value(forKey: forKey) {
            if let number = any as? NSNumber {
                return Int64(number.intValue)
            }else if let string = any as? NSString {
                return Int64(string.intValue)
            }
        }
        return 0
    }
    
    func getInt32Value(forKey: String) -> Int32 {
        if let any: Any = value(forKey: forKey) {
            if let number = any as? NSNumber {
                return Int32(number.intValue)
            }else if let string = any as? NSString {
                return Int32(string.intValue)
            }
        }
        return 0
    }
    
    func getInt16Value(forKey: String) -> Int16 {
        if let any: Any = value(forKey: forKey) {
            if let number = any as? NSNumber {
                return Int16(number.intValue)
            }else if let string = any as? NSString {
                return Int16(string.intValue)
            }
        }
        return 0
    }
    
    func getInt8Value(forKey: String) -> Int8 {
        if let any: Any = value(forKey: forKey) {
            if let number = any as? NSNumber {
                return Int8(number.intValue)
            }else if let string = any as? NSString {
                return Int8(string.intValue)
            }
        }
        return 0
    }

    func getStringValue(forKey: String) -> String {
        if let any: Any = value(forKey: forKey) {
            if let number = any as? NSNumber {
                return number.stringValue
            }else if let string = any as? String {
                return string
            }
        }
        return ""
    }

    func getStringValue(forKeyPath: String) -> String {
        if let any: Any = value(forKeyPath: forKeyPath) {
            if let number = any as? NSNumber {
                return number.stringValue
            }else if let number = any as? [NSNumber] {
                return number[0].stringValue
            }else if let string = any as? String {
                return string
            }else if let arrOfString = any as? [String] {
                return arrOfString[0]
            }
        }
        return ""
    }
    
    func getBooleanValue(forKey: String) -> Bool {
        if let any: Any = value(forKey: forKey) {
            if let number = any as? NSNumber {
                return number.boolValue
            }else if let string = any as? NSString {
                return string.boolValue
            }
        }
        return false
    }
}
