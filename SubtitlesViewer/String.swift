//
//  String.swift
//  SubtitlesViewer
//
//  Created by Carlos Duclos on 1/21/19.
//  Copyright © 2019 Carlos Duclos. All rights reserved.
//

import Foundation
import AppKit

extension String {
    
    var withoutHTML: String {
        return self.replacingOccurrences(of: "(?i)</?a-z\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    func convertHtml() -> NSAttributedString {
        do {
            let htmlCSSString = "<style>" +
                "html * {" +
                "font-size: \(24)pt !important;" +
                "color: #FFFFFF !important;" +
                "font-family: Helvetica !important;" +
                "}" +
                "p { text-align: center; }</style> <p>\(self)</p>"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return NSAttributedString()
            }
            
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]

            return try NSAttributedString(data: data, options: options, documentAttributes: nil)
            
        } catch {
            return NSAttributedString()
        }
    }
}
