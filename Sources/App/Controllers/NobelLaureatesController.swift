import Vapor

final class NobelLaureatesController {
    func getAll(
        req: Request
    ) throws -> Future<[NobelLaureates]> {
        let decodedLaureates = try NobelLaureates.loadFromFile()
        return req.future(decodedLaureates)
    }

    func getSingle(
        req: Request
    ) throws -> Future<NobelLaureates> {
        let laureatesID = try req.parameters.next(Int.self)
        let decodedLaureates = try NobelLaureates.loadFromFile()
        return try req.future(
            decodedLaureates.findOrThrow(id: laureatesID)
        )
    }
}

extension Sequence where Element == NobelLaureates {
    func findOrThrow(
        id: Int
    ) throws -> NobelLaureates {
        guard let laureate = self.first(where: { $0.id == id }) else {
            throw Abort(.notFound, reason: "No laureate matched the provided id")
        }
        return laureate
    }
}

extension NobelLaureatesController {
    func decodeNobelLaureatesFromData(
        req: Request
    ) throws -> LaureatesDecoderObject {
        let decoder = JSONDecoder()
        let laureatesData = try Data.fromFile("femaleNobelLaureates.json")
        return try decoder.decode(
            LaureatesDecoderObject.self,
            from: laureatesData
        )
    }

    struct LaureatesDecoderObject: Content {
        var data: [NobelLaureates]
    }
}
