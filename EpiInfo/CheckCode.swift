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
  
  func setTheWords(wds: NSArray) {
    self.words = wds
  }
  
  // Field that owns the CheckCode object calls this function when it resigns first responder
  func ownerDidResign() {
    // Get the owner's class description from the dictionary of fields, using the first CheckCode word
    let ownerClassDescription = dictionaryOfFields.objectForKey(words.objectAtIndex(0))?.description
    // Get the index of the first colon
    let idx: Int = ownerClassDescription!.startIndex.distanceTo((ownerClassDescription!.rangeOfString(":"))!.startIndex)
    // Start after the initial < and substring to that first colon to get the class of the owner
    let ownerClass = ownerClassDescription!.substringWithRange(Range<String.Index>(start: ownerClassDescription!.startIndex.advancedBy(1), end: ownerClassDescription!.startIndex.advancedBy(idx)))
    
    print("ownerClass name = " + ownerClass)
    print("ownerClass = " + ownerClassDescription!)
    var i = 0
    for word in words as! [NSString]
    {
      if i++ == 0 {continue}
      print(word)
    }
  }
}