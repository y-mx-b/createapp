import Foundation
import ArgumentParser

struct CreateApp: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A utility to automate creating apps.",
        subcommands: [CreateFromJson.self, CreateFromExecutable.self],
        defaultSubcommand: CreateFromJson.self)

    struct CreateFromJson: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Create an app from a JSON file.")

        @Argument var file: String = ".createapp.json"

        mutating func run() {
            let fman = FileManager.default
            let appData = fman.contents(atPath: file)
            let app = try? JSONDecoder().decode(AppJson.self, from: appData!)
            do {
                try createApp(app: app!)
            } catch {
            }
        }
    }

    struct CreateFromExecutable: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Create an app from an executable file.")

        @Argument var executable: String

        mutating func run() {
            let app = AppJson(from: executable)
            do {
                try createApp(app: app)
            } catch {
            }
        }
    }
}
