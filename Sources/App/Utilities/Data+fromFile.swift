import Core

extension Data {
    static func fromFile(
        _ fileName: String,
        folder: String = "Resources/json"
    ) throws -> Data {
        let directory = DirectoryConfig.detect()
        let fileURL = URL(fileURLWithPath: directory.workDir)
            .appendingPathComponent(folder, isDirectory: true)
            .appendingPathComponent(fileName, isDirectory: false)

        return try Data(contentsOf: fileURL)
    }
}
