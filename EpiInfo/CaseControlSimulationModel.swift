//
//  CaseControlSimulationModel.swift
//  EpiInfo
//
//  Created by John Copeland on 3/27/15.
//

import Foundation

class CaseControlSimulationModel {
  class func compute(_ a: Float, b: Float, c: Float, d: Float) -> (Int, Float, Float) {
    var significantCount : Int = 0
    
    for j in 0 ..< 1000 {
      var sickExposed : Int = 0
      for i in 0 ..< Int(a) {
        let randomNumber = (Float(arc4random()) / Float(UINT32_MAX)) * 100.0
        if randomNumber < c {
          sickExposed += 1
        }
      }
      
      var sickUnexposed : Int = 0
      for i in 0 ..< Int(b) {
        let randomNumber = (Float(arc4random()) / Float(UINT32_MAX)) * 100.0
        if randomNumber < d {
          sickUnexposed += 1
        }
      }
      
      let yy = Int32(sickExposed)
      let yn  = Int32(a - Float(sickExposed))
      let ny = Int32(sickUnexposed)
      let nn = Int32(b - Float(sickUnexposed))
      
      let computer = Twox2Compute()
      var RRStats : UnsafeMutablePointer<Double> = UnsafeMutablePointer<Double>.allocate(capacity: 12)
      
      let lcl = Float(computer.oddsRatioLower(yy, cellb: yn, cellc: ny, celld: nn))
      let ucl = Float(computer.oddsRatioUpper(yy, cellb: yn, cellc: ny, celld: nn))
      
      if c > d {
        if lcl > 1.0 {
          significantCount += 1
        }
      } else if d > c {
        if ucl < 1.0 {
          significantCount += 1
        }
      }
    }
    
    return (Int(roundf(Float(significantCount) / 10.0)), -1.0, 1.0)
  }
}
