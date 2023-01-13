import Foundation

struct InfoPlist: Codable {
    var CFBundleIdentifier: String
    var CFBundleName: String
    var CFBundleExecutable: String
    var CFBundleIconFile: String?
    var CFBundleVersion: String?

    init(from app: AppJson) {
        CFBundleIdentifier = app.bundleID
        CFBundleName = app.name
        CFBundleExecutable = app.name
        CFBundleIconFile = app.name + ".icns"
        CFBundleVersion = app.version
    }
}

func getName(file: String) -> String {
    return file.components(separatedBy: "/").last?
            .components(separatedBy: ".").first ?? ""
}
