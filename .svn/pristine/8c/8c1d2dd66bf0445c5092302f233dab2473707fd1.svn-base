//
//  CaseControlSimulationView.swift
//  EpiInfo
//
//  Created by John Copeland on 3/27/15.
//  Copyright (c) 2015 John Copeland. All rights reserved.
//

import UIKit

class CaseControlSimulationsView: UIView, UITextFieldDelegate {
  
  var fadingColorView = UIImageView()
  var resignAllButton = UIButton()
  var header = UILabel()
  var inputBackground = UIButton()
  var resultsLabel = EpiInfoMultiLineIndentedUILabel()
  var casesLabel = UIButton()
  var cases = NumberField()
  var controlsLabel = UIButton()
  var controls = NumberField()
  var percentCasesExposedLabel = UIButton()
  var percentCasesExposed = NumberField()
  var percentControlsExposedLabel = UIButton()
  var percentControlsExposed = NumberField()
  var maxWidth = CGFloat()
  var maxHeight = CGFloat()
  var killThread = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    if frame.height == 0.0 {
      return
    }
    
    self.clipsToBounds = true
    maxHeight = frame.height
    maxWidth = frame.width
    
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
    } else {
      // Add background image
      fadingColorView = UIImageView(frame: frame)
      let frameHeight: Float = Float(frame.size.height)
      if frameHeight > 500 {
        fadingColorView.image = UIImage(named: "iPhone5Background.png")
      } else {
        fadingColorView.image = UIImage(named: "iPhone4Background.png")
      }
      self.addSubview(fadingColorView)
      self.sendSubviewToBack(fadingColorView)
      
      //Add the screen-sized clear button to dismiss all keyboards
      resignAllButton = UIButton(frame: frame)
      resignAllButton.backgroundColor = .clearColor()
      resignAllButton.addTarget(self, action: "resignAll", forControlEvents: .TouchUpInside)
      self.addSubview(resignAllButton)
      
      //Screen header
      header = UILabel(frame: CGRectMake(0, 4 * (frame.height / maxHeight), frame.width * (frame.width / maxWidth), 26 * (frame.height / maxHeight)))
      header.backgroundColor = .clearColor()
      header.textColor = .whiteColor()
      header.textAlignment = .Center
      header.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
      header.text = "Simulate Case Control Study"
      self.addSubview(header)
      
      //Add navy background for input fields
      inputBackground = UIButton(frame: CGRectMake(4 * (frame.width / maxWidth), 40 * (frame.height / maxHeight), 312 * (frame.width / maxWidth), 170 * (frame.height / maxHeight)))
      inputBackground.backgroundColor = UIColor(red: 3/255.0, green: 36/255.0, blue: 77/255.0, alpha: 1.0)
      inputBackground.layer.masksToBounds = true
      inputBackground.layer.cornerRadius = 8.0
      inputBackground.addTarget(self, action: "resignAll", forControlEvents: .TouchUpInside)
      self.addSubview(inputBackground)
      
      //Add the NumberField for number of cases
      casesLabel = UIButton(frame: CGRectMake(4 * (frame.width / maxWidth), 2 * (frame.height / maxHeight), 148 * (frame.width / maxWidth), 40 * (frame.height / maxHeight)))
      casesLabel.backgroundColor = .clearColor()
      casesLabel.clipsToBounds = true
      casesLabel.setTitle("Number of Cases", forState: .Normal)
      casesLabel.contentHorizontalAlignment = .Left
      casesLabel.titleLabel!.textAlignment = .Left
      casesLabel.titleLabel!.textColor = .whiteColor()
      casesLabel.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
      casesLabel.addTarget(self, action: "resignAll", forControlEvents: .TouchUpInside)
      inputBackground.addSubview(casesLabel)
      
      cases = NumberField(frame: CGRectMake(230 * (frame.width / maxWidth), 2 * (frame.height / maxHeight), 80 * (frame.width / maxWidth), 40 * (frame.height / maxHeight)))
      cases.borderStyle = .RoundedRect
      cases.keyboardType = .NumberPad
      cases.delegate = self
      cases.returnKeyType = .Done
      inputBackground.addSubview(cases)
      
      //Add the NumberField for number of controls
      controlsLabel = UIButton(frame: CGRectMake(4 * (frame.width / maxWidth), 44 * (frame.height / maxHeight), 148 * (frame.width / maxWidth), 40 * (frame.height / maxHeight)))
      controlsLabel.backgroundColor = .clearColor()
      controlsLabel.clipsToBounds = true
      controlsLabel.setTitle("Number of Controls", forState: .Normal)
      controlsLabel.contentHorizontalAlignment = .Left
      controlsLabel.titleLabel!.textAlignment = .Left
      controlsLabel.titleLabel!.textColor = .whiteColor()
      controlsLabel.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
      controlsLabel.addTarget(self, action: "resignAll", forControlEvents: .TouchUpInside)
      inputBackground.addSubview(controlsLabel)
      
      controls = NumberField(frame: CGRectMake(230 * (frame.width / maxWidth), 44 * (frame.height / maxHeight), 80 * (frame.width / maxWidth), 40 * (frame.height / maxHeight)))
      controls.borderStyle = .RoundedRect
      controls.keyboardType = .NumberPad
      controls.delegate = self
      controls.returnKeyType = .Done
      inputBackground.addSubview(controls)
      
      //Add the NumberField for percent in cases
      percentCasesExposedLabel = UIButton(frame: CGRectMake(4 * (frame.width / maxWidth), 86 * (frame.height / maxHeight), 224 * (frame.width / maxWidth), 40 * (frame.height / maxHeight)))
      percentCasesExposedLabel.backgroundColor = .clearColor()
      percentCasesExposedLabel.clipsToBounds = true
      percentCasesExposedLabel.setTitle("Expected % Exposed in Cases", forState: .Normal)
      percentCasesExposedLabel.contentHorizontalAlignment = .Left
      percentCasesExposedLabel.titleLabel!.textAlignment = .Left
      percentCasesExposedLabel.titleLabel!.textColor = .whiteColor()
      percentCasesExposedLabel.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
      percentCasesExposedLabel.titleLabel?.adjustsFontSizeToFitWidth = true
      percentCasesExposedLabel.addTarget(self, action: "resignAll", forControlEvents: .TouchUpInside)
      inputBackground.addSubview(percentCasesExposedLabel)
      
      percentCasesExposed = NumberField(frame: CGRectMake(230 * (frame.width / maxWidth), 86 * (frame.height / maxHeight), 80 * (frame.width / maxWidth), 40 * (frame.height / maxHeight)))
      percentCasesExposed.borderStyle = .RoundedRect
      percentCasesExposed.keyboardType = .DecimalPad
      percentCasesExposed.delegate = self
      percentCasesExposed.returnKeyType = .Done
      inputBackground.addSubview(percentCasesExposed)
      
      //Add the NumberField for percent in controls
      percentControlsExposedLabel = UIButton(frame: CGRectMake(4 * (frame.width / maxWidth), 128 * (frame.height / maxHeight), 224 * (frame.width / maxWidth), 40 * (frame.height / maxHeight)))
      percentControlsExposedLabel.backgroundColor = .clearColor()
      percentControlsExposedLabel.clipsToBounds = true
      percentControlsExposedLabel.setTitle("Expected % Exposed in Controls", forState: .Normal)
      percentControlsExposedLabel.contentHorizontalAlignment = .Left
      percentControlsExposedLabel.titleLabel!.textAlignment = .Left
      percentControlsExposedLabel.titleLabel!.textColor = .whiteColor()
      percentControlsExposedLabel.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
      percentControlsExposedLabel.titleLabel?.adjustsFontSizeToFitWidth = true
      percentControlsExposedLabel.addTarget(self, action: "resignAll", forControlEvents: .TouchUpInside)
      inputBackground.addSubview(percentControlsExposedLabel)
      
      percentControlsExposed = NumberField(frame: CGRectMake(230 * (frame.width / maxWidth), 128 * (frame.height / maxHeight), 80 * (frame.width / maxWidth), 40 * (frame.height / maxHeight)))
      percentControlsExposed.borderStyle = .RoundedRect
      percentControlsExposed.keyboardType = .DecimalPad
      percentControlsExposed.delegate = self
      percentControlsExposed.returnKeyType = .Done
      inputBackground.addSubview(percentControlsExposed)
      
      //Add the results label
      resultsLabel = EpiInfoMultiLineIndentedUILabel(frame: CGRectMake(4, frame.height - 60, 312, 60))
      resultsLabel.backgroundColor = UIColor(red: 3/255.0, green: 36/255.0, blue: 77/255.0, alpha: 1.0)
      resultsLabel.layer.masksToBounds = true
      resultsLabel.layer.cornerRadius = 8.0
      resultsLabel.textColor = .whiteColor()
      resultsLabel.textAlignment = .Left
      resultsLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
      resultsLabel.numberOfLines = 0
      resultsLabel.numLines = 2
      resultsLabel.lineBreakMode = .ByWordWrapping
      self.addSubview(resultsLabel)
      resultsLabel.hidden = true
    }
  }
  
  func changeFrame(frame: CGRect) {
    self.frame = frame
    fadingColorView.frame = CGRectMake(0, 0, frame.width, frame.height)
    resignAllButton.frame = fadingColorView.frame
    if frame.width < maxWidth {
      header.transform = CGAffineTransformScale(header.transform , 10 / maxWidth, 10 / maxHeight)
    } else {
      header.transform = CGAffineTransformScale(header.transform , maxWidth / 10, maxHeight / 10)
    }
    header.frame = CGRectMake(0, 4 * (frame.height / maxHeight), frame.width * (frame.width / maxWidth), 26 * (frame.height / maxHeight))
    inputBackground.frame = CGRectMake(4 * (frame.width / maxWidth), 40 * (frame.height / maxHeight), 312 * (frame.width / maxWidth), 170 * (frame.height / maxHeight))
    casesLabel.frame = CGRectMake(4 * (frame.width / maxWidth), 2 * (frame.height / maxHeight), 148 * (frame.width / maxWidth), 40 * (frame.height / maxHeight))
    cases.frame = CGRectMake(230 * (frame.width / maxWidth), 2 * (frame.height / maxHeight), 80 * (frame.width / maxWidth), 40 * (frame.height / maxHeight))
    controlsLabel.frame = CGRectMake(4 * (frame.width / maxWidth), 44 * (frame.height / maxHeight), 148 * (frame.width / maxWidth), 40 * (frame.height / maxHeight))
    controls.frame = CGRectMake(230 * (frame.width / maxWidth), 44 * (frame.height / maxHeight), 80 * (frame.width / maxWidth), 40 * (frame.height / maxHeight))
    percentCasesExposedLabel.frame = CGRectMake(4 * (frame.width / maxWidth), 86 * (frame.height / maxHeight), 224 * (frame.width / maxWidth), 40 * (frame.height / maxHeight))
    percentCasesExposed.frame = CGRectMake(230 * (frame.width / maxWidth), 86 * (frame.height / maxHeight), 80 * (frame.width / maxWidth), 40 * (frame.height / maxHeight))
    percentControlsExposedLabel.frame = CGRectMake(4 * (frame.width / maxWidth), 128 * (frame.height / maxHeight), 224 * (frame.width / maxWidth), 40 * (frame.height / maxHeight))
    percentControlsExposed.frame = CGRectMake(230 * (frame.width / maxWidth), 128 * (frame.height / maxHeight), 80 * (frame.width / maxWidth), 40 * (frame.height / maxHeight))
    if !resultsLabel.hidden {
      resultsLabel.frame = CGRectMake(resultsLabel.frame.origin.x * (frame.width / maxWidth), resultsLabel.frame.origin.y * (frame.height / maxHeight), resultsLabel.frame.width * (frame.width / maxWidth), resultsLabel.frame.height * (frame.height / maxHeight))
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    killThread = true
    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
      self.resultsLabel.frame = CGRectMake(4, self.frame.height - 60, 312, 60)
      }, completion: {
        (value: Bool) in
        self.resultsLabel.hidden = true
        self.resultsLabel.text = ""
    })
    return true
  }
  
  func resignAll() {
    var noFirstResponder = true
    for v in inputBackground.subviews as! [UIView] {
      if let tf = v as? UITextField {
        if tf.isFirstResponder() {
          tf.resignFirstResponder()
          noFirstResponder = false
        }
      }
    }
    if (noFirstResponder) {
      return
    }
    
    if cases.text?.characters.count > 0 && controls.text?.characters.count > 0 && percentCasesExposed.text?.characters.count > 0 && percentControlsExposed.text?.characters.count > 0 {
      let numCases = (cases.text! as NSString).floatValue
      let numControls = (controls.text! as NSString).floatValue
      let pctCasesExposed = (percentCasesExposed.text! as NSString).floatValue
      let pctControlsExposed = (percentControlsExposed.text! as NSString).floatValue
      
      if pctCasesExposed > 100 {
        percentCasesExposed.text = ""
        percentCasesExposed.placeholder = "<=100"
        return
      } else if pctControlsExposed > 100 {
        percentControlsExposed.text = ""
        percentControlsExposed.placeholder = "<=100"
        return
      }
      
      killThread = false
      let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
      dispatch_async(queue) {
        self.runComputer((numCases, numControls, pctCasesExposed, pctControlsExposed))
      }
      resultsLabel.hidden = false
      UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
        self.resultsLabel.frame = CGRectMake(self.resultsLabel.frame.origin.x, self.inputBackground.frame.origin.y + self.inputBackground.frame.height + 8, self.resultsLabel.frame.width, self.resultsLabel.frame.height)
        }, completion: {
          (value: Bool) in
      })
    }
  }
  
  func runComputer(inputs : (Float, Float, Float, Float)) {
    while !killThread {
      let rr = CaseControlSimulationModel.compute(inputs.0, b: inputs.1, c: inputs.2, d: inputs.3)
      dispatch_async(dispatch_get_main_queue()) {
        self.resultsLabel.text = "\(rr.0)% of simulations found a significant relative risk."
      }
      sleep(2)
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}