import Foundation

struct InfoPlist: Encodable {
    var bundleID: String
    var name: String
    var executable: String
    var icon: String?
    var version: String?

    init(from app: App) {
        bundleID = app.bundleID
        name = app.name
        executable = app.name
        icon = app.name + ".icns"
        version = app.version
    }
}

extension InfoPlist {
    enum CodingKeys: String, CodingKey {
        case bundleID = "CFBundleIdentifier"
        case name = "CFBundleName"
        case executable = "CFBundleExecutable"
        case icon = "CFBundleIconFile"
        case version = "CFBundleVersion"
    }
}

func getName(file: String) -> String {
    return (file as NSString).lastPathComponent as String
}
