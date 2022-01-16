//
//  Extensions.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/16.
//

import Foundation

extension String{
  func regex(regex: String) -> [String]?{
    do {
        let regex = try NSRegularExpression(pattern: regex, options: NSRegularExpression.Options(rawValue: 0))
        let all = NSRange(location: 0, length: count)
        var matches = [String]()
        regex.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: all) {
            (result : NSTextCheckingResult?, _, _) in
              if let r = result {
                    let nsstr = self as NSString
                    let result = nsstr.substring(with: r.range) as String
                    matches.append(result)
              }
        }
        return matches
    } catch {
        return nil
    }
  }
}
