import Foundation

struct AppJson: Codable {
    var bundleID: String
    var name: String
    var executable: String
    var icon: String?
    var version: String?
    var assets: [String]?

    init(from executable: String) {
        bundleID = "com.example.www"
        name = getName(file: executable)
        self.executable = executable
        icon = nil
        version = nil
        assets = nil
    }
}

func createInfoPlist(app: AppJson) throws -> Data {
    return try PropertyListEncoder().encode(InfoPlist(from: app))
}

func createApp(app: AppJson) throws {
    let fman = FileManager.default
    // create app structure
    let appContents = "\(app.name).app/Contents"
    try fman.createDirectory(atPath: "\(appContents)", withIntermediateDirectories: true)
    try fman.createDirectory(atPath: "\(appContents)/MacOS", withIntermediateDirectories: false)
    try fman.createDirectory(atPath: "\(appContents)/Resources", withIntermediateDirectories: false)

    // fill app (executable, icon, assets)
    try fman.copyItem(atPath: app.executable, toPath: "\(appContents)/MacOS/\(app.name)")
    if let icon = app.icon {
        try fman.copyItem(atPath: icon, toPath: "\(appContents)/Resources/\(app.name).icns")
    }
    if let assets = app.assets {
        for asset in assets {
            try fman.copyItem(atPath: asset, toPath: "\(appContents)/Resources/\(asset.split(separator: "/").last!)")
        }
    }

    // create Info.plist
    let data = try createInfoPlist(app: app)
    fman.createFile(atPath: "\(appContents)/Info.plist", contents: data)
}