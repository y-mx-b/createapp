import Foundation
import ArgumentParser

enum Method: String, ExpressibleByArgument {
    case json
    case executable, exec
}

enum FileError: LocalizedError {
    case nilContents(path: String)

    public var errorDescription: String? {
        switch self {
        case .nilContents(let path):
            return "Failed to read from file: \(path)"
        }
    }
}

struct Createapp: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Create apps easily from the terminal.",
        discussion: """
            Configure a JSON file to automate creating an app or quickly mock-up an app from an executable
            """)

    @Argument(help: "The file to use to create an app.",
              completion: .file())
    var file: String = ".createapp.json"

    @Flag(help: "Display extra information.")
    var verbose = false

    @Option(name: [.short, .long], completion: .list(["json", "exec"]), help: """
            Define the method for generating the app.
            Possible Values: [json, exec]
            """)
    var method: Method = .json

    mutating func run() {
        let fman = FileManager.default
        var app: AppJson
        do {
            switch method {
            case .json:
                verbosePrint(verbose, "Reading from JSON file: \(file)")
                guard let appData = fman.contents(atPath: file) else {
                    throw FileError.nilContents(path: file)
                }
                verbosePrint(verbose, "Initializing app struct from JSON file: \(file)")
                app = try JSONDecoder().decode(AppJson.self, from: appData)
            case .executable, .exec:
                verbosePrint(verbose, "Initializing app struct from executable file: \(file)")
                app = AppJson(from: file)
            }
            verbosePrint(verbose, "Creating app.")
            try createApp(app: app)
        } catch {
            print(error.localizedDescription)

        }
    }
}

func verbosePrint(_ verbose: Bool, _ text: String) {
    if verbose {
        print(text)
    }
}
