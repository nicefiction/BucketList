// Result.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/downloading-data-from-wikipedia
// https://www.hackingwithswift.com/books/ios-swiftui/sorting-wikipedia-results

// MARK: - LIBRARIES -

import Foundation


struct Result: Codable {
   
   var query: Query
}



struct Query: Codable {
   
   var pages: [Int: Page]
}



struct Page: Codable {
   
   // MARK: - PROPERTIES
   
   let pageid: Int
   let title: String
   let terms: [String: [String]]?
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var description: String {
      
      return terms?["description"]?.first ?? "N/A"
      /// Wikipedia’s JSON data does contain a `description` , but it’s buried :
      /// the `terms dictionary` might not be there ,
      /// and if it is there
      /// it might not have a `description key` ,
      /// and if it has a `description key`
      /// it might be an `empty array` rather than an array with some text inside .
   }
}





// MARK: - EXTENSIONS

extension Page: Comparable {
   
   static func < (lhs: Page,
                  rhs: Page)
   -> Bool {
      
      return lhs.title < rhs.title
   }
}
