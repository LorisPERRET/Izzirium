//
//  UserDefaults+Properties.swift
//  Data
//
//  Created by Thibaut Schmitt on 18/04/2025.
//

import SKDependencyInjection
import SKLocalStorage

public import Foundation

///
/// Important note about Codable objects in UserDefaults :
///
/// If you need to access the publisher and sink value, you're Codable object
/// must be a class and implement NSObject protocol :
///
///     public class Foo: NSObject, Codable {
///         public var bar: String
///     }
///
/// And your properties in this file marked as @objc :
///
///     @objc public dynamic var shouldShowOnboarding: Bool {
///         get { bool(forKey: "shouldShowOnboarding") }
///         set { setValue(newValue, forKey: "shouldShowOnboarding") }
///     }
///
/// Using this setup, you'll be able to sink changes :
///
///     userDefaultsStorage.userDefaults
///         .publisher(for: \.fooIsOnboarded)
///         .sink { [weak self] receiveValue in
///             ...
///         }
///         .store(in: &cancellables)
///
///
/// If you don't need the publisher, you can use a simple struct :
///
///     struct Foo: Codable {
///         var bar: String
///     }
///
/// With a property not marked with @objc :
///
///     public dynamic var foo: Foo? {
///         get { decodeObject(forKey: "foo") }
///         set { encodeObject(newValue, forKey: "foo") }
///     }
///
extension UserDefaults {

    // MARK: Properties

    @objc dynamic var favoriteAquariumId: NSNumber? {
        get {
            return object(forKey: #function) as? NSNumber
        }
        set {
            setValue(newValue, forKey: #function)
        }
    }

    dynamic var pairedBLEDevices: [PairedBLEDevice] {
        get {
            decodeObject(forKey: #function) ?? []
        }
        set {
            encodeObject(newValue, forKey: #function)
        }
    }

    // MARK: Private methods

    private func decodeObject<T: Codable>(forKey key: String) -> T? {
        guard let data = object(forKey: key) as? Data else { return nil }

        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .formatted(.localStorage_iso8601Full)

        return try? decoder.decode(T.self, from: data)
    }

    private func encodeObject(_ object: Encodable, forKey key: String) {
        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .formatted(.localStorage_iso8601Full)

        let data = try? encoder.encode(object)

        setValue(data, forKey: key)
    }
}
