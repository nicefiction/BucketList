// MKPointAnnotation+ObservableObject.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/extending-existing-types-to-support-observableobject

// MARK: - LIBRARIES -

import SwiftUI
import MapKit


extension MKPointAnnotation: ObservableObject {
   
   public var computedTitle: String {
      get {
         return title ?? "N/A"
      }
      set {
         return title = newValue
      }
   }
   
   
   public var computedSubtitle: String {
      get {
         return subtitle ?? "N/A"
      }
      set {
         return subtitle = newValue
      }
   }
}

/// `NOTE`
/// Notice how I haven’t marked those computed properties as `@Published` ?
/// This is OK here
/// because we won’t actually be reading the properties as they are being changed ,
/// so there is no need to keep refreshing the view as the user types .
