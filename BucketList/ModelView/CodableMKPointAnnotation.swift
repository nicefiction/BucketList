// CodableMKPointAnnotation.swift

// MARK: - LIBRARIES -

import Foundation
import MapKit



final class CodableMKPointAnnotation: MKPointAnnotation,
                                      Codable {
   
   // MARK: - NESTED TYPES
   
   enum CodingKeys: String,
                    CodingKey {
      case title
      case subtitle
      case latitude
      case longitude
   }
   
   
   // MARK: - INITIALIZER METHODS
   
   override init() {
      
      super.init()
   }
   
   
   init(from decoder: Decoder)
   throws {
      
      super.init()
      
      let decodingContainer = try decoder.container(keyedBy: CodingKeys.self)
      
      self.title = try decodingContainer.decode(String.self, forKey: CodingKeys.title)
      self.subtitle = try decodingContainer.decode(String.self, forKey: CodingKeys.subtitle)
      
      let latitude = try decodingContainer.decode(CLLocationDegrees.self, forKey: CodingKeys.latitude)
      let longitude = try decodingContainer.decode(CLLocationDegrees.self, forKey: CodingKeys.longitude)
      self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
   }
   
   
   
   // MARK: - METHODS
   
   func encode(to encoder: Encoder)
   throws {
      
      var encodingContainer = encoder.container(keyedBy: CodingKeys.self)
      
      try encodingContainer.encode(title, forKey: CodingKeys.title)
      try encodingContainer.encode(subtitle, forKey: CodingKeys.subtitle)
      try encodingContainer.encode(coordinate.latitude, forKey: CodingKeys.latitude)
      try encodingContainer.encode(coordinate.longitude, forKey: CodingKeys.longitude)
   }
}
