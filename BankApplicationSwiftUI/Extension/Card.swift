//
//  Card.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 24/4/24.
//

import CoreData
import UIKit
import SwiftUI

extension Card {
    static func fetchSampleCard() -> Card? {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        fetchRequest.fetchLimit = 1 // Fetch only one card for preview
        do {
            let cards = try context.fetch(fetchRequest)
            return cards.first
        } catch {
            print("Error fetching card for preview: \(error.localizedDescription)")
            return nil
        }
    }
}

extension UIColor {
    class func color(data: Data) -> UIColor? {
        do {
            if let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) {
                return color
            } else {
                print("Failed to unarchive color data")
                return nil
            }
        } catch {
            print("Error unarchiving color data: \(error.localizedDescription)")
            return nil
        }
    }

    func encode() -> Data? {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            return data
        } catch {
            print("Error archiving color: \(error.localizedDescription)")
            return nil
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            let hScale = newSize.height / size.height
            let vScale = newSize.width / size.width
            let scale = max(hScale, vScale) // scaleToFill
            let resizeSize = CGSize(width: size.width*scale, height: size.height*scale)
            var middle = CGPoint.zero
            if resizeSize.width > newSize.width {
                middle.x -= (resizeSize.width-newSize.width)/2.0
            }
            if resizeSize.height > newSize.height {
                middle.y -= (resizeSize.height-newSize.height)/2.0
            }
            
            draw(in: CGRect(origin: middle, size: resizeSize))
        }
    }
}

extension Color {
    static let cardBackground = Color("cardTransactionBackground")
}
