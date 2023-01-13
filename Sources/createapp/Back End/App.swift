import Foundation

struct App: Decodable {
    var bundleID: String
    var name: String
    var executable: String
    var icon: String?
    var version: String?
    var assets: [String]?

    // -m exec
    init(from executable: String) {
        bundleID = "com.example.www"
        name = getName(file: executable)
        self.executable = executable
        icon = nil
        version = nil
        assets = nil
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
        let appContents = "\(self.name).app/Contents"
        try fman.createDirectory(atPath: "\(appContents)", withIntermediateDirectories: true)
        try fman.createDirectory(atPath: "\(appContents)/MacOS", withIntermediateDirectories: false)
        try fman.createDirectory(atPath: "\(appContents)/Resources", withIntermediateDirectories: false)

        // fill app (executable, icon, assets)
        try fman.copyItem(atPath: self.executable, toPath: "\(appContents)/MacOS/\(self.name)")
        if let icon = self.icon {
            try fman.copyItem(atPath: icon, toPath: "\(appContents)/Resources/\(self.name).icns")
        }
        if let assets = self.assets {
            for asset in assets {
                try fman.copyItem(atPath: asset,
                                  toPath: "\(appContents)/Resources/\(asset.split(separator: "/").last!)")
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
        case bundleID
        case name
        case executable
        case icon
        case version
        case assets
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        bundleID = try values.decode(String.self, forKey: .bundleID)
        name = try values.decode(String.self, forKey: .name)
        executable = try values.decode(String.self, forKey: .executable)
        icon = try values.decode(String?.self, forKey: .icon)
        version = try values.decode(String.self, forKey: .version)
        assets = try values.decode([String]?.self, forKey: .assets)
    }
}
