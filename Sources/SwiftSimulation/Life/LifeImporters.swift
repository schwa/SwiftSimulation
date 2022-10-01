import Everything
import Foundation

public extension Bundle {
    static let everything = Bundle.module
}

public enum LifeImporterError: Swift.Error {
    case unknown
}

public func life105_importer(named name: String) throws -> Array2D<UInt8> {
    let url = Bundle.module.resourceURL!.appendingPathComponent("Patterns/\(name).lif")
    return try life105_importer(url: url)
}

// http://www.conwaylife.com/wiki/Life_1.05
public func life105_importer(url: URL) throws -> Array2D<UInt8> {
    let data = try Data(contentsOf: url)
    let string = String(bytes: data, encoding: .ascii)!

    let lines = string.components(separatedBy: .newlines)
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .filter { $0.isEmpty == false }

    var iterator = lines.makeIterator()

    guard let firstLine = iterator.next() else {
        throw LifeImporterError.unknown
    }
    if firstLine != "#Life 1.05" {
        throw LifeImporterError.unknown
    }

    var line: String! = iterator.next()
    while line != nil {
        if line.hasPrefix("#D") {
        }
        else if line.hasPrefix("#N") {
        }
        else if line.hasPrefix("#P") {
        }
        else {
            break
        }
        line = iterator.next()
    }

    let rowStrings: [String] = [line] + Array(iterator)

    let size = IntSize(
        width: rowStrings.reduce(0) { max($1.count, $0) },
        height: rowStrings.count
    )
    let rows: [[UInt8]] = try rowStrings.map {
        try $0.map {
            switch $0 {
            case "*":
                return 1
            case ".":
                return 0
            default:
                throw LifeImporterError.unknown
            }
        }
    }
    .map { (row: [UInt8]) -> [UInt8] in
        if row.count == size.width {
            return row
        }
        else {
            return row + Array(repeatElement(0, count: size.width - row.count))
        }
    }
    let array = Array2D<UInt8>(flatStorage: Array(rows.joined()), size: size)
    return array
}
