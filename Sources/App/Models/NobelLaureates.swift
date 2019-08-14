import Vapor

final class NobelLaureates: Codable {
    var id: Int
    var fullName: String
    var category: String
    var year: Int
    var rationale: String
    var isShared: Bool

    init(
        id: Int,
        fullName: String,
        category: String,
        year: Int,
        rationale: String,
        isShared: Bool
    ) {
        self.id = id
        self.fullName = fullName
        self.category = category
        self.year = year
        self.rationale = rationale
        self.isShared = isShared
    }
}

extension NobelLaureates: Content {}

extension NobelLaureates {
    static func loadFromFile(
        _ fileName: String = "femaleNobelLaureates.json"
    ) throws -> [NobelLaureates] {
        let decoder = JSONDecoder()
        let laureatesData = try Data.fromFile(fileName)
        let decodedNobelLaureates = try decoder.decode(
            LaureatesDecoderObject.self,
            from: laureatesData
        )
        return decodedNobelLaureates.data
    }

    private struct LaureatesDecoderObject: Content {
        var data: [NobelLaureates]
    }
}
