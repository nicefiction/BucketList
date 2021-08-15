// Result.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/downloading-data-from-wikipedia

// MARK: - LIBRARIES -

import Foundation


struct Result: Codable {
   
   var query: Query
}



struct Query: Codable {
   
   var pages: [Int: Page]
}



struct Page: Codable {
   
   let pageid: Int
   let title: String
   let terms: [String: [String]]?
   
   
}
