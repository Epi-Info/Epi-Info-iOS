//
//  CohortSimulationModel.swift
//  EpiInfo
//
//  Created by John Copeland on 3/9/15.
//

import Foundation

class CohortSimulationModel {
  class func compute(a: Float, b: Float, c: Float, d: Float) -> (Int, Float, Float) {
    var significantCount : Int = 0
    
    for var j = 0; j < 1000; j++ {
      var sickExposed : Int = 0
      for var i = 0; i < Int(a); i++ {
        let randomNumber = (Float(arc4random()) / Float(UINT32_MAX)) * 100.0
        if randomNumber < c {
          sickExposed++
        }
      }
      
      var sickUnexposed : Int = 0
      for var i = 0; i < Int(b); i++ {
        let randomNumber = (Float(arc4random()) / Float(UINT32_MAX)) * 100.0
        if randomNumber < d {
          sickUnexposed++
        }
      }
      
      let yy = Int32(sickExposed)
      let yn  = Int32(a - Float(sickExposed))
      let ny = Int32(sickUnexposed)
      let nn = Int32(b - Float(sickUnexposed))
      
      let computer = Twox2Compute()
      var RRStats : UnsafeMutablePointer<Double> = UnsafeMutablePointer<Double>.alloc(12)
      computer.RRStats(yy, RRSb: yn, RRSc: ny, RRSd: nn, RRSstats: RRStats)
      
      if c > d {
        if RRStats[1] > 1.0 {
          significantCount++
        }
      } else if d > c {
        if RRStats[2] < 1.0 {
          significantCount++
        }
      }
    }
    
    return (Int(roundf(Float(significantCount) / 10.0)), -1.0, 1.0)
  }
}