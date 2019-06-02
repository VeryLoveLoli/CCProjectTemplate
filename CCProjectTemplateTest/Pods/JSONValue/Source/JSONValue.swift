//
//  JSONValue.swift
//  JSONValueDemo
//
//  Created by 韦烽传 on 2017/5/25.
//  Copyright © 2017年 韦烽传. All rights reserved.
//

import Foundation

// MARK: - 数值

/**
 *  Number
 *  简易快捷数值取值
 */
public struct Number {
    
    private var value: String
    
    public init()              {  value = ""     }
    public init(_ v: Int)      {  value = "\(v)" }
    public init(_ v: Int8)     {  value = "\(v)" }
    public init(_ v: Int16)    {  value = "\(v)" }
    public init(_ v: Int32)    {  value = "\(v)" }
    public init(_ v: Int64)    {  value = "\(v)" }
    
    public init(_ v: UInt)     {  value = "\(v)" }
    public init(_ v: UInt8)    {  value = "\(v)" }
    public init(_ v: UInt16)   {  value = "\(v)" }
    public init(_ v: UInt32)   {  value = "\(v)" }
    public init(_ v: UInt64)   {  value = "\(v)" }

    public init(_ v: Float)    {  value = "\(v)" }
    public init(_ v: Double)   {  value = "\(v)" }
    public init(_ v: Bool)     {  value = v ? "1" : "0" }
    public init(_ v: String)   {  value = v }

    public var int:    Int     { get { return value.int } set { value = "\(newValue)" } }
    public var int8:   Int8    { get { return value.int8 } set { value = "\(newValue)" } }
    public var int16:  Int16   { get { return value.int16 } set { value = "\(newValue)" } }
    public var int32:  Int32   { get { return value.int32 } set { value = "\(newValue)" } }
    public var int64:  Int64   { get { return value.int64 } set { value = "\(newValue)" } }

    public var uint:   UInt    { get { return value.uint } set { value = "\(newValue)" } }
    public var uint8:  UInt8   { get { return value.uint8 } set { value = "\(newValue)" } }
    public var uint16: UInt16  { get { return value.uint16 } set { value = "\(newValue)" } }
    public var uint32: UInt32  { get { return value.uint32 } set { value = "\(newValue)" } }
    public var uint64: UInt64  { get { return value.uint64 } set { value = "\(newValue)" } }
    
    public var float:  Float   { get { return value.float } set { value = "\(newValue)" } }
    public var double: Double  { get { return value.double } set { value = "\(newValue)" } }
    public var bool:   Bool    { get { return value.bool } set { value = "\(newValue)" } }
    public var string: String  { get { return  value } set { value = newValue } }
}

// MARK: - Number 等号 赋值

extension Number: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, ExpressibleByBooleanLiteral, ExpressibleByStringLiteral {
    
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
    
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

// MARK: - String -> 数值

public extension String {
    
    var int:    Int     { get {  return Int(self.double) } }
    var int8:   Int8    { get { return Int8( (self.int << 56) >> 56 ) } }
    var int16:  Int16   { get { return Int16( (self.int << 48) >> 48 ) } }
    var int32:  Int32   { get { return Int32( (self.int << 32) >> 32 ) } }
    var int64:  Int64   { get { return Int64( self.int ) } }
    
    var uint:   UInt    { get { return self.double <= -1 ? (UInt.max - UInt(-self.int) + 1) : (self.double < 0 ? 0 : UInt(self.double)) } }
    var uint8:  UInt8   { get { return UInt8( self.uint % ( UInt(UInt8.max) + 1 ) ) } }
    var uint16: UInt16  { get { return UInt16( self.uint % ( UInt(UInt16.max) + 1 ) ) } }
    var uint32: UInt32  { get { return UInt32( self.uint % ( UInt(UInt32.max) + 1 ) ) } }
    var uint64: UInt64  { get { return UInt64( self.uint ) } }
    
    var float:  Float   { get { return Float.init(self) ?? 0 } }
    var double: Double  { get { return Double.init(self) ?? 0 } }
    var bool:   Bool    { get { return self != "" && self != "0" && self != "false" } }
}

// MARK: - 基本类型 -> Number

public extension Int       { var number: Number { return Number(self) } }
public extension Int8      { var number: Number { return Number(self) } }
public extension Int16     { var number: Number { return Number(self) } }
public extension Int32     { var number: Number { return Number(self) } }
public extension Int64     { var number: Number { return Number(self) } }

public extension UInt      { var number: Number { return Number(self) } }
public extension UInt8     { var number: Number { return Number(self) } }
public extension UInt16    { var number: Number { return Number(self) } }
public extension UInt32    { var number: Number { return Number(self) } }
public extension UInt64    { var number: Number { return Number(self) } }

public extension Float     { var number: Number { return Number(self) } }
public extension Double    { var number: Number { return Number(self) } }
public extension Bool      { var number: Number { return Number(self) } }
public extension String    { var number: Number { return Number(self) } }

// MARK: - 基本类型 -> JSON

public extension Int       { var json: JSONValue { return JSONValue(self) } }
public extension Int8      { var json: JSONValue { return JSONValue(self) } }
public extension Int16     { var json: JSONValue { return JSONValue(self) } }
public extension Int32     { var json: JSONValue { return JSONValue(self) } }
public extension Int64     { var json: JSONValue { return JSONValue(self) } }

public extension UInt      { var json: JSONValue { return JSONValue(self) } }
public extension UInt8     { var json: JSONValue { return JSONValue(self) } }
public extension UInt16    { var json: JSONValue { return JSONValue(self) } }
public extension UInt32    { var json: JSONValue { return JSONValue(self) } }
public extension UInt64    { var json: JSONValue { return JSONValue(self) } }

public extension Float     { var json: JSONValue { return JSONValue(self) } }
public extension Double    { var json: JSONValue { return JSONValue(self) } }
public extension Bool      { var json: JSONValue { return JSONValue(self) } }
public extension String    { var json: JSONValue { return JSONValue(self) } }

public extension Number    { var json: JSONValue { return JSONValue(self) } }
public extension Array     { var json: JSONValue { return JSONValue(self) } }
public extension Dictionary{ var json: JSONValue { return JSONValue(self) } }
public extension Data      { var json: JSONValue { return JSONValue(self) } }

// MARK: - JSON类型

public enum JSONType {
    
    /// 数组
    case array
    /// 字典
    case dictionary
    /// 数组
    case number
    /// 空
    case empty
}

// MARK: - JSON数据取值

/**
 *  JSONValue
 *  简易快捷JSON数据取值
 */
@dynamicMemberLookup
public struct JSONValue {
    
    // MARK: init
    
    public init(_ object: Any? = nil) {
        
        if let value = object {
            
            switch value {
                
            case let json as JSONValue:
                
                self = json
                
            case let string as String:
                
                if let data = string.data(using: .utf8), !data.isEmpty {
                    
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        
                        switch json {
                        case let a as Array<Any>:
                            valueType = .array
                            array = a.map{ JSONValue($0) }
                        case let d as Dictionary<String, Any>:
                            valueType = .dictionary
                            for (k,v) in d {
                                dictionary[k] = JSONValue(v)
                            }
                        default:
                            valueType = .number
                            number = Number(string)
                        }
                        
                    } catch  {
                        
                        valueType = .number
                        number = Number(string)
                    }
                }
                else {
                    
                    valueType = .number
                    number = Number(string)
                }
                
            case let data as Data:
                
                if !data.isEmpty {
                    
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        
                        switch json {
                        case let a as Array<Any>:
                            valueType = .array
                            array = a.map{ JSONValue($0) }
                        case let d as Dictionary<String, Any>:
                            valueType = .dictionary
                            for (k,v) in d {
                                dictionary[k] = JSONValue(v)
                            }
                        default:
                            if let string = String.init(data: data, encoding: .utf8) {
                                
                                valueType = .number
                                number = Number(string)
                            }
                        }
                        
                    } catch  {
                        
                        if let string = String.init(data: data, encoding: .utf8) {
                            
                            valueType = .number
                            number = Number(string)
                        }
                    }
                }
                
            case let n as Number:
                
                valueType = .number
                number = n
                
            case let int as Int:
                
                valueType = .number
                number = Number(int)
                
            case let int8 as Int8:
                
                valueType = .number
                number = Number(int8)
                
            case let int16 as Int16:
                
                valueType = .number
                number = Number(int16)
                
            case let int32 as Int32:
                
                valueType = .number
                number = Number(int32)
                
            case let int64 as Int64:
                
                valueType = .number
                number = Number(int64)
                
            case let uint as UInt:
                
                valueType = .number
                number = Number(uint)
                
            case let uint8 as UInt8:
                
                valueType = .number
                number = Number(uint8)
                
            case let uint16 as UInt16:
                
                valueType = .number
                number = Number(uint16)
                
            case let uint32 as UInt32:
                
                valueType = .number
                number = Number(uint32)
                
            case let uint64 as UInt64:
                
                valueType = .number
                number = Number(uint64)
                
            case let bool as Bool:
                
                valueType = .number
                number = Number(bool)

            case let float as Float:
                
                valueType = .number
                number = Number(float)
            
            case let double as Double:
                
                valueType = .number
                number = Number(double)
                
            case let a as Array<Any>:
                
                valueType = .array
                array = a.map{ JSONValue($0) }
                
            case let d as Dictionary<String, Any?>:
                
                valueType = .dictionary
                for (k,v) in d {
                    dictionary[k] = JSONValue(v)
                }
                
            case _ as NSNull:
                
                valueType = .empty
                
            default:
                
                #if DEBUG
                print("JSONValue value not an dictionary or array or number or empty")
                #endif
            }
        }
    }
    
    // MARK: Parameter
    
    /// 类型
    public private(set) var valueType = JSONType.empty
    /// 字典
    public private(set) var dictionary = Dictionary<String, JSONValue>()
    /// 数组
    public private(set) var array = Array<JSONValue>()
    /// 数值
    public private(set) var number = Number()
    
    // MARK: Subscript
    
    /**
     数组下标
     */
    public subscript(_ index: Int) -> JSONValue {
        
        get {
            
            if valueType == .array && array.count>index {
                return array[index]
            }
            return JSONValue()
        }
        set {
            
            switch valueType {
            case .array:
                if array.count > index {
                    array[index] = newValue
                }
                else {
                    array.append(newValue)
                }
            case .empty:
                valueType = .array
                array.append(newValue)
            default:
                #if DEBUG
                print("JSONValue not an array or empty")
                #endif
            }
        }
    }
    
    /**
     字典下标
     */
    public subscript(index: String) -> JSONValue {
        
        get {
            
            if valueType == .dictionary, let value = dictionary[index] {
                return value
            }
            return JSONValue()
        }
        
        set {
            
            switch valueType {
            case .dictionary:
                dictionary[index] = newValue
            case .empty:
                valueType = .dictionary
                dictionary[index] = newValue
            default:
                #if DEBUG
                print("JSONValue not an dictionary or empty")
                #endif
            }
        }
    }
    
    /**
     下标组
     */
    public subscript(indexes: [Any]) -> JSONValue {
        
        get {
            
            switch indexes.count {
                
            case 0:
                return self
            case 1:
                switch indexes[0] {
                    
                case let string as String:
                    return self[string]
                case let int as Int:
                    return self[int]
                default:
                    return JSONValue()
                }
            default:
                var items = indexes
                let first = items.remove(at: 0)
                return self[[first]][items]
            }
        }
        set {
            
            switch indexes.count {
                
            case 0:
                return
            case 1:
                switch indexes[0] {
                    
                case let string as String:
                    self[string] = newValue
                case let int as Int:
                    self[int] = newValue
                default:
                    return
                }
            default:
                var items = indexes
                let first = items.remove(at: 0)
                self[[first]][items] = newValue
            }
        }
    }
    
    /**
     动态下标
     */
    public subscript(dynamicMember index: String) -> JSONValue {
        
        get {
            
            if let i = Int(index), valueType == .array || valueType == .empty {
                
                return self[i]
            }
            else {
                
                return self[index]
            }
        }
        set {
            
            if let i = Int(index), valueType == .array || valueType == .empty {
                
                self[i] = newValue
            }
            else {
                
                self[index] = newValue
            }
        }
    }
    
    /**
     插入/添加 数组元素
     */
    public mutating func insert(_ json: JSONValue, index: Int = Int.max) {
        
        if valueType == .empty {
            
            valueType = .array
        }
        
        if valueType == .array {
            
            if array.count > index {
                
                array.insert(json, at: index)
            }
            else {
                
                array.append(json)
            }
        }
        else {
            
            #if DEBUG
            print("JSONValue not an array or empty")
            #endif
        }
    }
    
    /**
     删除数组元素
     */
    public mutating func remove(_ index: Int) {
        
        if valueType == .array {
            
            array.remove(at: index)
        }
    }
    
    /**
     删除字典元素
     */
    public mutating func remove(_ key: String) {
        
        if valueType == .dictionary {
            
            dictionary.removeValue(forKey: key)
        }
    }
    
    /**
     JSON格式化字符串
     
     - parameter    isValueObject:      是否是 数组/字典 元素值
     - parameter    isPrettyPrinted:    是否漂亮的格式
     - parameter    level:              层次字符串
     */
    public func JSONFormatString(_ isValueObject: Bool = false, isPrettyPrinted: Bool = false, level: String = "") -> String {
        
        switch valueType {
            
        case .number:
            if isValueObject {
                var value = number.string.replacingOccurrences(of: "\\", with: "\\\\")
                value = value.replacingOccurrences(of: "\"", with: "\\\"")
                value = value.replacingOccurrences(of: "\n", with: "\\n")
                value = value.replacingOccurrences(of: "\r", with: "\\r")
                value = value.replacingOccurrences(of: "\t", with: "\\t")
                return "\"\(value)\""
            }
            else {
                return number.string
            }
        case .array:
            var arrayString = "["
            for item in array {
                if isPrettyPrinted {
                    arrayString += "\n\t" + level
                }
                arrayString += item.JSONFormatString(true, isPrettyPrinted: isPrettyPrinted, level: isPrettyPrinted ? level + "\t" : level)
                arrayString += ","
            }
            if array.count > 0 {
                arrayString.remove(at: arrayString.index(before: arrayString.endIndex))
            }
            if isPrettyPrinted {
                arrayString += "\n" + level
            }
            arrayString += "]"
            return arrayString
        case .dictionary:
            var dictionaryString = "{"
            for (key,value) in dictionary {
                if isPrettyPrinted {
                    dictionaryString += "\n\t" + level
                }
                dictionaryString += "\""
                dictionaryString += key
                dictionaryString += "\""
                dictionaryString += ":"
                if isPrettyPrinted {
                    dictionaryString += " "
                }
                dictionaryString += value.JSONFormatString(true, isPrettyPrinted: isPrettyPrinted, level: isPrettyPrinted ? level + "\t" : level)
                dictionaryString += ","
            }
            if dictionary.count > 0 {
                
                dictionaryString.remove(at: dictionaryString.index(before: dictionaryString.endIndex))
            }
            if isPrettyPrinted {
                dictionaryString += "\n" + level
            }
            dictionaryString += "}"
            return dictionaryString
        case .empty:
            return isValueObject ? "null" : ""
        }
    }
    
    /**
     JSON格式化字数据
     
     - parameter    isValueObject:      是否是 数组/字典 元素值
     - parameter    isPrettyPrinted:    是否漂亮的格式
     - parameter    level:              层次字符串
     */
    public func JSONFormatData(_ isValueObject: Bool = false, isPrettyPrinted: Bool = false, level: String = "") -> Data {
        
        return JSONFormatString(isValueObject, isPrettyPrinted: isPrettyPrinted, level: level).data(using: .utf8) ?? Data.init()
    }
    
    /**
     是否是空值
     */
    public func isEmpty() -> Bool {
        
        switch valueType {
        case .dictionary:
            return dictionary.isEmpty
        case .array:
            return array.isEmpty
        case .number:
            return number.string.isEmpty
        case .empty:
            return true
        }
    }
    
    /**
     格式输出
     */
    public func formatPrint() {
        
        #if DEBUG
        print(JSONFormatString(isPrettyPrinted: true))
        #endif
    }
}
