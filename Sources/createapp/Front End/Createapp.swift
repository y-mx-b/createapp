import Foundation
import ArgumentParser

enum Method: String, CaseIterable, ExpressibleByArgument {
    case json
    case executable, exec
}

enum FileError: LocalizedError {
    case nilContents(path: String)

    public var errorDescription: String? {
        switch self {
        case let .nilContents(path):
            return "Failed to read from file: \(path)"
        }
    }
}

struct Createapp: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Create apps easily from the terminal.",
        discussion: """
            Configure a JSON file to automate creating an app or quickly mock-up an app from an executable
            """
    )

    @Argument(
        help: "The file to use to create an app.",
        completion: .file()
    )
    var file: String = ".createapp.json"

    @Flag(help: "Display extra information.")
    var verbose = false

    @Option(name: [.short, .long], help: """
        Define the method for generating the app.
        Possible Values: [json, exec]
        """)
    var method: Method = .json

    mutating func run() {
        let fman = FileManager.default
        var app: App
        do {
            switch method {
            case .json:
                verbosePrint("Reading from JSON file: \(file)")
                guard let appData = fman.contents(atPath: file) else {
                    throw FileError.nilContents(path: file)
                }
                verbosePrint("Initializing app struct from JSON file: \(file)")
                app = try JSONDecoder().decode(App.self, from: appData)
            case .executable, .exec:
                verbosePrint("Initializing app struct from executable file: \(file)")
                app = App(from: file)
            }
            verbosePrint("Creating app.")
            try app.createApp()
        } catch {
            print(error.localizedDescription)
        }
    }

    func verbosePrint(_ text: String) {
        if self.verbose {
            print(text)
        }
    }
}
