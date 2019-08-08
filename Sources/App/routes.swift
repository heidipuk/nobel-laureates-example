import Vapor

public func routes(_ router: Router) throws {
    router.get { req in
        return "It works!"
    }

    let nobelLaureatesMockAPI = NobelLaureatesController()
    router.get(
        "api/laureates",
        use: nobelLaureatesMockAPI.getAll
    )
    router.get(
        "api/laureates", Int.parameter,
        use: nobelLaureatesMockAPI.getSingle
    )
}
