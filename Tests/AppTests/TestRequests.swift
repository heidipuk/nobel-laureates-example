@testable import App
import Vapor 
import XCTest

final class TestRequests: XCTestCase {
    var eventLoopGroup: EventLoopGroup!
    var eventLoop: EventLoop!
    var container: Container!
    var request: Request!
    var services: Services!

    override func setUp() {
        eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        eventLoop = eventLoopGroup.next()
        services = Services.default()
        services.register(ContentCoders.self)
        container = BasicContainer(
            config: .init(),
            environment: .testing,
            services: services,
            on: eventLoop
        )

        let url = URL(string: "api/laureates/7")!
        let httpRequest = HTTPRequest(method: .GET, url: url)
        request = Request(http: httpRequest, using: container)
    }

    func testGetSingleLaureateOnRequest() throws {
        let router = EngineRouter.default()
        struct TestResponder: Responder {
            func respond(to req: Request) throws -> EventLoopFuture<Response> {
                var headers: HTTPHeaders = HTTPHeaders()
                headers.add(name: .contentType, value: "application/json")
                let laureatesAPI = NobelLaureatesController()

                return try laureatesAPI
                    .getSingle(req: req)
                    .encode(status: .ok, headers: headers, for: req)
            }
        }
        router.register(route: Route(
            path: ["GET", "api", "laureates", Int.parameter],
            output: TestResponder()
        ))
        let responder = router.route(request: request)
        let response = try responder!.respond(to: request).wait()
        let decoder = JSONDecoder()
        let laureate = try response.content.decode(
            json: NobelLaureates.self,
            using: decoder
            ).wait()
        XCTAssertEqual(laureate.fullName, "Rosalyn Sussman Yalow") // Success, the seventh woman to receive a Nobel price was Rosalyn Sussman Yalow
    }

    static let allTests = [
        ("testGetSingleLaureateOnRequest", testGetSingleLaureateOnRequest)
    ]
}
