import Foundation

extension String {
    func toURL() -> URL {
        return URL(fileURLWithPath: self)
    }
}

struct App: Decodable {
    var version: String?
    var bundleID: String
    var name: String
    // URLs (internal)
    var executable: URL { return URL(fileURLWithPath: executablePath) }
    var icon: URL? { return URL(fileURLWithPath: iconPath ?? "") }
    var assets: [URL]? { return assetPaths.map { $0.map { $0.toURL() } } }
    // Path strings (external)
    var executablePath: String
    var iconPath: String?
    var assetPaths: [String]?

    // -m exec
    init(from executablePath: String) {
        version = nil
        bundleID = "com.example.www"
        name = getName(file: executablePath)
        self.executablePath = executablePath
        iconPath = nil
        assetPaths = nil
    }
}

// methods
extension App {
    func createInfoPlist() throws -> Data {
        return try PropertyListEncoder().encode(InfoPlist(from: self))
    }

    func createApp() throws {
        let fman = FileManager.default
        // create app structure
        let appContents = URL(fileURLWithPath: "\(self.name).app/Contents",
                              relativeTo: URL(fileURLWithPath: fman.currentDirectoryPath))
        let appResources = appContents.appendingPathComponent("Resources", isDirectory: true)
        let appMacOS = appContents.appendingPathComponent("MacOS", isDirectory: true)

        try fman.createDirectory(at: appContents, withIntermediateDirectories: true)
        try fman.createDirectory(at: appMacOS, withIntermediateDirectories: false)
        try fman.createDirectory(at: appResources, withIntermediateDirectories: false)

        // fill app (executable, icon, assets)
        try fman.copyItem(at: self.executable,
                          to: appMacOS.appendingPathComponent(executable.lastPathComponent,
                                                              isDirectory: false))
        if let icon = self.icon {
            try fman.copyItem(at: icon,
                              to: appResources.appendingPathComponent(icon.lastPathComponent,
                                                                  isDirectory: false))
        }
        if let assets = self.assets {
            for asset in assets {
                try fman.copyItem(at: asset,
                                  to: appResources.appendingPathComponent(asset.lastPathComponent,
                                                                          isDirectory: false))
            }
        }

        // create Info.plist
        let data = try self.createInfoPlist()
        fman.createFile(atPath: "\(appContents)/Info.plist", contents: data)
    }
}

// boilerplate
extension App {
    enum CodingKeys: String, CodingKey {
        case version
        case bundleID
        case name
        case executablePath = "executable"
        case iconPath = "icon"
        case assetPaths = "assets"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        version = try values.decode(String.self, forKey: .version)
        bundleID = try values.decode(String.self, forKey: .bundleID)
        name = try values.decode(String.self, forKey: .name)
        executablePath = try values.decode(String.self, forKey: .executablePath)
        iconPath = try values.decode(String?.self, forKey: .iconPath)
        assetPaths = try values.decode([String]?.self, forKey: .assetPaths)
    }
}
