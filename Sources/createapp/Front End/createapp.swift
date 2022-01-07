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

struct CreateApp: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A utility to automate creating apps.")

    @Flag(help: "Display extra information.")
    var verbose = false

    @Option(name: [.short, .long],
            help: "Define the method for generating the app.")
    var method: Method = .json

    @Argument(help: "The file to use to create an app.",
              completion: CompletionKind.file())
    var file: String = ".createapp.json"

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
