//
//  File.swift
//  
//
//  Created by 韦烽传 on 2021/2/2.
//

import Foundation

/**
 CC输出
 */
open class CCPrint {
    
    /**
     等级
     */
    public enum Level: Int {
        
        /// 调试
        case debug = 0
        /// 信息
        case info
        /// 警告
        case warning
        /// 错误
        case error
        /// 最高等级，用于不输出
        case max
    }
    
    /**
     文件输出流
     */
    struct FileHandlerOutputStream: TextOutputStream {
        
        /// 文件句柄
        private let fileHandle: FileHandle
        
        /// 编码
        let encoding: String.Encoding
        
        /**
         初始化
         */
        init(_ fileHandle: FileHandle, encoding: String.Encoding = .utf8) {
            
            self.fileHandle = fileHandle
            self.encoding = encoding
        }
        
        // MARK: - TextOutputStream
        
        /**
         写文件
         */
        mutating func write(_ string: String) {
            
            if let data = string.data(using: encoding) {
                
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
            }
        }
        
        /**
         关闭文件
         */
        func close() {
            
            fileHandle.closeFile()
        }
    }

    
    /// 等级
    public static var level: CCPrint.Level = .debug
    /// 是否显示输出时间
    public static var isTime = false
    /// 是否显示输出文件
    public static var isFile = false
    /// 是否显示输出函数
    public static var isFunction = false
    /// 是否显示输出行号
    public static var isLine = false
    /// 日志路径
    public static var path = FileManager.documentsPath + "CCPrint/"
    /// 队列
    public static var queue = DispatchQueue(label: "CCPrint.serial")
    
    /**
     等级输出
     */
    public static func level(_ lv: CCPrint.Level, value: Any , separator: String = " ", terminator: String = "\n", file: String = #file, funcName: String = #function, line: Int = #line) {
        
        queue.async {
            
            if lv.rawValue >= level.rawValue {
                
                var list: [String] = []
                
                if isTime {
                    
                    list.append(Date().format("yyyy-MM-dd HH:mm:ss.SSS"))
                }
                
                if isFile {
                    
                    list.append("\(file.components(separatedBy: "/").last ?? file)")
                }
                
                if isFunction {
                    
                    list.append("\(funcName)")
                }
                
                if isLine {
                    
                    list.append("line: \(line)")
                }
                
                let string = list.joined(separator: separator)
                
                #if DEBUG
                
                if !string.isEmpty {
                    
                    print(string, separator: separator, terminator: separator)
                }
                
                print(value, separator: separator, terminator: terminator)
                
                #endif
                
                if path.createDirectory() {
                    
                    let file = path + "\(Date().format("yyyy-MM-dd")).log"
                    
                    if !FileManager.default.fileExists(atPath: file) {
                        
                        if !FileManager.default.createFile(atPath: file, contents: Data.init(), attributes: nil) {
                        
                            return
                        }
                    }
                    
                    let url = URL(fileURLWithPath: file)
                        
                    do {
                        
                        let fileHandle = try FileHandle(forWritingTo: url)
                        
                        var output = FileHandlerOutputStream(fileHandle)
                        
                        if !string.isEmpty {
                            
                            _print([string], separator: separator, terminator: separator, to: &output)
                        }
                        
                        _print([value], separator: separator, terminator: terminator, to: &output)
                        
                        output.close()
                        
                    } catch {
                        
                        print(error)
                    }
                }
            }
        }
    }
    
    /**
     调试
     */
    public static func debug(_ value: Any, separator: String = " ", terminator: String = "\n", file: String = #file, funcName: String = #function, line: Int = #line) {
        
        level(.debug, value: value, separator: separator, terminator: terminator, file: file, funcName: funcName, line: line)
    }
    
    /**
     信息
     */
    public static func info(_ value: Any, separator: String = " ", terminator: String = "\n", file: String = #file, funcName: String = #function, line: Int = #line) {
        
        level(.info, value: value, separator: separator, terminator: terminator, file: file, funcName: funcName, line: line)
    }
    
    /**
     警告
     */
    public static func warning(_ value: Any, separator: String = " ", terminator: String = "\n", file: String = #file, funcName: String = #function, line: Int = #line) {
        
        level(.warning, value: value, separator: separator, terminator: terminator, file: file, funcName: funcName, line: line)
    }
    
    /**
     错误
     */
    public static func error(_ value: Any, separator: String = " ", terminator: String = "\n", file: String = #file, funcName: String = #function, line: Int = #line) {
        
        level(.error, value: value, separator: separator, terminator: terminator, file: file, funcName: funcName, line: line)
    }
    
    /**
     保留日志
     
     - parameter    day:    最近几天（`0`即删除所有）
     */
    public static func keepLog(_ day: Int) {
        
        let date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - TimeInterval(day)*24*60*60)
        
        let string = date.format("yyyy-MM-dd") + ".log"
        
        if let array = FileManager.default.subpaths(atPath: path) {
            
            for item in array {
                
                if item.contains(".log") && item <= string {
                    
                    do {
                        
                        try FileManager.default.removeItem(atPath: path + item)
                        
                    } catch {
                        
                        CCPrint.error(error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - 输出源码

internal func _print<Target: TextOutputStream>(
  _ items: [Any],
  separator: String = " ",
  terminator: String = "\n",
  to output: inout Target
) {
  var prefix = ""
  output._lock()
  defer { output._unlock() }
  for item in items {
    output.write(prefix)
    _print_unlocked(item, &output)
    prefix = separator
  }
  output.write(terminator)
}

@_silgen_name("swift_EnumCaseName")
internal func _getEnumCaseName<T>(_ value: T) -> UnsafePointer<CChar>?

@_silgen_name("swift_OpaqueSummary")
internal func _opaqueSummary(_ metadata: Any.Type) -> UnsafePointer<CChar>?

/// Do our best to print a value that cannot be printed directly.
@_semantics("optimize.sil.specialize.generic.never")
internal func _adHocPrint_unlocked<T, TargetStream: TextOutputStream>(
    _ value: T, _ mirror: Mirror, _ target: inout TargetStream,
    isDebugPrint: Bool
) {
  func printTypeName(_ type: Any.Type) {
    // Print type names without qualification, unless we're debugPrint'ing.
    target.write(_typeName(type, qualified: isDebugPrint))
  }

  if let displayStyle = mirror.displayStyle {
    switch displayStyle {
      case .optional:
        if let child = mirror.children.first {
          _debugPrint_unlocked(child.1, &target)
        } else {
          _debugPrint_unlocked("nil", &target)
        }
      case .tuple:
        target.write("(")
        var first = true
        for (label, value) in mirror.children {
          if first {
            first = false
          } else {
            target.write(", ")
          }

          if let label = label {
            if !label.isEmpty && label[label.startIndex] != "." {
              target.write(label)
              target.write(": ")
            }
          }

          _debugPrint_unlocked(value, &target)
        }
        target.write(")")
      case .struct:
        printTypeName(mirror.subjectType)
        target.write("(")
        var first = true
        for (label, value) in mirror.children {
          if let label = label {
            if first {
              first = false
            } else {
              target.write(", ")
            }
            target.write(label)
            target.write(": ")
            _debugPrint_unlocked(value, &target)
          }
        }
        target.write(")")
      case .enum:
        if let cString = _getEnumCaseName(value),
            let caseName = String(validatingUTF8: cString) {
          // Write the qualified type name in debugPrint.
          if isDebugPrint {
            printTypeName(mirror.subjectType)
            target.write(".")
          }
          target.write(caseName)
        } else {
          // If the case name is garbage, just print the type name.
          printTypeName(mirror.subjectType)
        }
        if let (_, value) = mirror.children.first {
          if Mirror(reflecting: value).displayStyle == .tuple {
            _debugPrint_unlocked(value, &target)
          } else {
            target.write("(")
            _debugPrint_unlocked(value, &target)
            target.write(")")
          }
        }
      default:
        target.write(_typeName(mirror.subjectType))
    }
  } else if let metatypeValue = value as? Any.Type {
    // Metatype
    printTypeName(metatypeValue)
  } else {
    // Fall back to the type or an opaque summary of the kind
    if let cString = _opaqueSummary(mirror.subjectType),
        let opaqueSummary = String(validatingUTF8: cString) {
      target.write(opaqueSummary)
    } else {
      target.write(_typeName(mirror.subjectType, qualified: true))
    }
  }
}

@usableFromInline
@_semantics("optimize.sil.specialize.generic.never")
internal func _print_unlocked<T, TargetStream: TextOutputStream>(
  _ value: T, _ target: inout TargetStream
) {
  // Optional has no representation suitable for display; therefore,
  // values of optional type should be printed as a debug
  // string. Check for Optional first, before checking protocol
  // conformance below, because an Optional value is convertible to a
  // protocol if its wrapped type conforms to that protocol.
  // Note: _isOptional doesn't work here when T == Any, hence we
  // use a more elaborate formulation:
  if _openExistential(type(of: value as Any), do: _isOptional) {
    let debugPrintable = value as! CustomDebugStringConvertible
    debugPrintable.debugDescription.write(to: &target)
    return
  }

  if let string = value as? String {
    target.write(string)
    return
  }

  if case let streamableObject as TextOutputStreamable = value {
    streamableObject.write(to: &target)
    return
  }

  if case let printableObject as CustomStringConvertible = value {
    printableObject.description.write(to: &target)
    return
  }

  if case let debugPrintableObject as CustomDebugStringConvertible = value {
    debugPrintableObject.debugDescription.write(to: &target)
    return
  }

  let mirror = Mirror(reflecting: value)
  _adHocPrint_unlocked(value, mirror, &target, isDebugPrint: false)
}
