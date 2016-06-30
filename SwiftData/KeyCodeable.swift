//
//  KeyCodeable.swift
//  SwiftData
//
//  Created by Ahmed Onawale on 6/29/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
//  THE POSSIBILITY OF SUCH DAMAGE.
//

import CoreData

/// This protocol outline requirements for a type that can
/// represent it's properties as a RawRepresentable type.
public protocol KeyCodeable {
    associatedtype Key: RawRepresentable
}

/*
 Extension methods for updating and getting NSManagedObject properties.
 NSManagedObject must conform to KeyCodeable and Key must be Hashable
 and has a RawValue of typeString
 */
public extension KeyCodeable where Self: NSManagedObject, Key: Hashable, Key.RawValue == String {
    /// Method to update the properties of a NSManagedObject.
    /// - Parameter properties: A dictionary of type [Key: AnyObject], where Key is RawRepresentable.
    func setProperties(properties: [Key: AnyObject]) {
        let dictionary = properties.reduce([:]) { (previous, next) -> [String: AnyObject] in
            var previous = previous
            previous[next.0.rawValue] = next.1
            return previous
        }
        setValuesForKeysWithDictionary(dictionary)
    }
    
    /// Method to update the properties of a NSManagedObject.
    /// - Parameter properties: A dictionary of type [Key: AnyObject], where Key is RawRepresentable.
    func update(properties: [Key: AnyObject]) {
        setProperties(properties)
    }
    
    /// Method to get the values of properties of a NSManagedObject.
    /// - Parameter properties: An array of type Key, where Key is RawRepresentable.
    func getProperties(properties: [Key]) -> [String: AnyObject] {
        return dictionaryWithValuesForKeys(properties.map { $0.rawValue })
    }
    
    /// Method to get the values of properties of a NSManagedObject.
    /// - Parameter properties: An array of type Key, where Key is RawRepresentable.
    func get(properties: [Key]) -> [String: AnyObject] {
        return getProperties(properties)
    }
}

/*
 Extension methods for creating NSManagedObject type that conforms to KeyCodeable.
 */
public extension KeyCodeable where Self: NSManagedObject, Key: Hashable, Key.RawValue == String {
    /// Creates a new instance of type Self with default properties values.
    /// - Parameter properties: A dictionary of type [Key: AnyObject], where Key is RawRepresentable.
    /// - Returns: A new instance of object type Self.
    static func create(properties: [Key: AnyObject]) -> Self {
        return NSManagedObjectContext.defaultContext().create(self, properties: properties)
    }
    
    /// Creates new instances of type Self with default properties values.
    /// - Parameter properties: A comma separated list of dictionaries of type [Key: AnyObject], where Key is RawRepresentable.
    ///   Each dictionary for each instances of objects created.
    /// - Returns: An array of new instance of objects type Self.
    static func bulkCreate(properties: [Key: AnyObject]...) -> [Self] {
        return properties.map { NSManagedObjectContext.defaultContext().create(self, properties: $0) }
    }
}