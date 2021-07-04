//
//  KanjiBezierPathesHelper.swift
//  Pods
//
//  Created by Andriy K. on 12/25/15.
//
//

#if os(OSX)
import AppKit
public typealias BezierPath = NSBezierPath
#else
import UIKit
public typealias BezierPath = UIBezierPath
#endif

import RealmSwift
import Realm

class Kanji: Object {
    @objc dynamic var id = ""
    @objc dynamic var data = Data()
    override class func primaryKey() -> String? {
        return "id"
    }
}

public class KanjiProvider {
    
    private struct Constants {
        static let encodedBezierClass = "UIBezierPath"
        static let kanjiRealmFilename = "KanjiBezierPaths_kanji"
        static let realmExtension = "realm"
        static let scheme: UInt64 = 6
    }
    
    public static let bundle: Bundle = {
        return Bundle(for: KanjiProvider.self)
    }()
    
    public init() throws {
        let bundleUrl = Bundle.module.url(forResource: Constants.kanjiRealmFilename, withExtension: Constants.realmExtension)!
        Realm.Configuration.defaultConfiguration = Realm.Configuration(readOnly: true,
                                                                       schemaVersion: Constants.scheme,
                                                                       migrationBlock: { _, _ in },
                                                                       objectTypes: [KanjiStrokesKit.Kanji.self])
        realm = try Realm(fileURL: bundleUrl)
    }
    
    let realm: Realm
    
    public func pathesForKanji(_ kanji: String) -> [BezierPath]? {
        guard let kanjiObj = realm.object(ofType: Kanji.self, forPrimaryKey: kanji) else { return nil }
        let data = kanjiObj.data
        
        #if os(OSX)
        NSKeyedUnarchiver.setClass(BezierPath.self, forClassName: Constants.encodedBezierClass)
        #endif
        let result = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: BezierPath.self, from: data)
        return result
    }
    
    func allKanjiArray() -> [[BezierPath]] {
        return realm.objects(Kanji.self).compactMap { pathesForKanji($0.id) }
    }
    
}
