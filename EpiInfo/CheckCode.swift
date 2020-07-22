//
//  CheckCode.swift
//  EpiInfo
//
//  Created by John Copeland on 5/13/15.
//

import Foundation

class CheckCode: NSObject {
  var words = NSArray()
  var dictionaryOfFields = NSDictionary()
  
  override init() {
    super.init()
  }
  
  func setTheWords(_ wds: NSArray) {
    self.words = wds
  }
  
  // Field that owns the CheckCode object calls this function when it resigns first responder
  func ownerDidResign() {
    // Get the owner's class description from the dictionary of fields, using the first CheckCode word
    let ownerClassDescription = (dictionaryOfFields.object(forKey: words.object(at: 0)) as AnyObject).description
    // Get the index of the first colon
    let idx: Int = ownerClassDescription!.distance(from: ownerClassDescription!.startIndex, to: (ownerClassDescription!.range(of: ":"))!.lowerBound)
    // Start after the initial < and substring to that first colon to get the class of the owner
//    let ownerClass = ownerClassDescription!.substring(with: (ownerClassDescription!.index(ownerClassDescription!.startIndex, offsetBy: 1) ..< ownerClassDescription!.index(ownerClassDescription!.startIndex, offsetBy: idx)))
    let ownerClass = String(ownerClassDescription![(ownerClassDescription!.index(ownerClassDescription!.startIndex, offsetBy: 1) ..< ownerClassDescription!.index(ownerClassDescription!.startIndex, offsetBy: idx))])
    
    print("ownerClass name = " + ownerClass)
    print("ownerClass = " + ownerClassDescription!)
    var i = 0
    for word in words as! [NSString]
    {
        i += 1
      if i == 0 {continue}
      print(word)
    }
  }
}
