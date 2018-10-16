//
//  CaseControlSimulationView.swift
//  EpiInfo
//
//  Created by John Copeland on 3/27/15.
//  Copyright (c) 2015 John Copeland. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
    
    if UIDevice.current.userInterfaceIdiom == .pad {
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
      self.sendSubview(toBack: fadingColorView)
      
      //Add the screen-sized clear button to dismiss all keyboards
      resignAllButton = UIButton(frame: frame)
      resignAllButton.backgroundColor = .clear
      resignAllButton.addTarget(self, action: #selector(CaseControlSimulationsView.resignAll), for: .touchUpInside)
      self.addSubview(resignAllButton)
      
      //Screen header
      header = UILabel(frame: CGRect(x: 0, y: 4 * (frame.height / maxHeight), width: frame.width * (frame.width / maxWidth), height: 26 * (frame.height / maxHeight)))
      header.backgroundColor = .clear
      header.textColor = .white
      header.textAlignment = .center
      header.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
      header.text = "Simulate Case Control Study"
      self.addSubview(header)
      
      //Add navy background for input fields
      inputBackground = UIButton(frame: CGRect(x: 4 * (frame.width / maxWidth), y: 40 * (frame.height / maxHeight), width: 312 * (frame.width / maxWidth), height: 170 * (frame.height / maxHeight)))
      inputBackground.backgroundColor = UIColor(red: 3/255.0, green: 36/255.0, blue: 77/255.0, alpha: 1.0)
      inputBackground.layer.masksToBounds = true
      inputBackground.layer.cornerRadius = 8.0
      inputBackground.addTarget(self, action: #selector(CaseControlSimulationsView.resignAll), for: .touchUpInside)
      self.addSubview(inputBackground)
      
      //Add the NumberField for number of cases
      casesLabel = UIButton(frame: CGRect(x: 4 * (frame.width / maxWidth), y: 2 * (frame.height / maxHeight), width: 148 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      casesLabel.backgroundColor = .clear
      casesLabel.clipsToBounds = true
      casesLabel.setTitle("Number of Cases", for: UIControlState())
      casesLabel.contentHorizontalAlignment = .left
      casesLabel.titleLabel!.textAlignment = .left
      casesLabel.titleLabel!.textColor = .white
      casesLabel.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
      casesLabel.addTarget(self, action: #selector(CaseControlSimulationsView.resignAll), for: .touchUpInside)
      inputBackground.addSubview(casesLabel)
      
      cases = NumberField(frame: CGRect(x: 230 * (frame.width / maxWidth), y: 2 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      cases.borderStyle = .roundedRect
      cases.keyboardType = .numberPad
      cases.delegate = self
      cases.returnKeyType = .done
      inputBackground.addSubview(cases)
      
      //Add the NumberField for number of controls
      controlsLabel = UIButton(frame: CGRect(x: 4 * (frame.width / maxWidth), y: 44 * (frame.height / maxHeight), width: 148 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      controlsLabel.backgroundColor = .clear
      controlsLabel.clipsToBounds = true
      controlsLabel.setTitle("Number of Controls", for: UIControlState())
      controlsLabel.contentHorizontalAlignment = .left
      controlsLabel.titleLabel!.textAlignment = .left
      controlsLabel.titleLabel!.textColor = .white
      controlsLabel.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
      controlsLabel.addTarget(self, action: #selector(CaseControlSimulationsView.resignAll), for: .touchUpInside)
      inputBackground.addSubview(controlsLabel)
      
      controls = NumberField(frame: CGRect(x: 230 * (frame.width / maxWidth), y: 44 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      controls.borderStyle = .roundedRect
      controls.keyboardType = .numberPad
      controls.delegate = self
      controls.returnKeyType = .done
      inputBackground.addSubview(controls)
      
      //Add the NumberField for percent in cases
      percentCasesExposedLabel = UIButton(frame: CGRect(x: 4 * (frame.width / maxWidth), y: 86 * (frame.height / maxHeight), width: 224 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      percentCasesExposedLabel.backgroundColor = .clear
      percentCasesExposedLabel.clipsToBounds = true
      percentCasesExposedLabel.setTitle("Expected % Exposed in Cases", for: UIControlState())
      percentCasesExposedLabel.contentHorizontalAlignment = .left
      percentCasesExposedLabel.titleLabel!.textAlignment = .left
      percentCasesExposedLabel.titleLabel!.textColor = .white
      percentCasesExposedLabel.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
      percentCasesExposedLabel.titleLabel?.adjustsFontSizeToFitWidth = true
      percentCasesExposedLabel.addTarget(self, action: #selector(CaseControlSimulationsView.resignAll), for: .touchUpInside)
      inputBackground.addSubview(percentCasesExposedLabel)
      
      percentCasesExposed = NumberField(frame: CGRect(x: 230 * (frame.width / maxWidth), y: 86 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      percentCasesExposed.borderStyle = .roundedRect
      percentCasesExposed.keyboardType = .decimalPad
      percentCasesExposed.delegate = self
      percentCasesExposed.returnKeyType = .done
      inputBackground.addSubview(percentCasesExposed)
      
      //Add the NumberField for percent in controls
      percentControlsExposedLabel = UIButton(frame: CGRect(x: 4 * (frame.width / maxWidth), y: 128 * (frame.height / maxHeight), width: 224 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      percentControlsExposedLabel.backgroundColor = .clear
      percentControlsExposedLabel.clipsToBounds = true
      percentControlsExposedLabel.setTitle("Expected % Exposed in Controls", for: UIControlState())
      percentControlsExposedLabel.contentHorizontalAlignment = .left
      percentControlsExposedLabel.titleLabel!.textAlignment = .left
      percentControlsExposedLabel.titleLabel!.textColor = .white
      percentControlsExposedLabel.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
      percentControlsExposedLabel.titleLabel?.adjustsFontSizeToFitWidth = true
      percentControlsExposedLabel.addTarget(self, action: #selector(CaseControlSimulationsView.resignAll), for: .touchUpInside)
      inputBackground.addSubview(percentControlsExposedLabel)
      
      percentControlsExposed = NumberField(frame: CGRect(x: 230 * (frame.width / maxWidth), y: 128 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      percentControlsExposed.borderStyle = .roundedRect
      percentControlsExposed.keyboardType = .decimalPad
      percentControlsExposed.delegate = self
      percentControlsExposed.returnKeyType = .done
      inputBackground.addSubview(percentControlsExposed)
      
      //Add the results label
      resultsLabel = EpiInfoMultiLineIndentedUILabel(frame: CGRect(x: 4, y: frame.height - 60, width: 312, height: 60))
      resultsLabel.backgroundColor = UIColor(red: 3/255.0, green: 36/255.0, blue: 77/255.0, alpha: 1.0)
      resultsLabel.layer.masksToBounds = true
      resultsLabel.layer.cornerRadius = 8.0
      resultsLabel.textColor = .white
      resultsLabel.textAlignment = .left
      resultsLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
      resultsLabel.numberOfLines = 0
      resultsLabel.numLines = 2
      resultsLabel.lineBreakMode = .byWordWrapping
      self.addSubview(resultsLabel)
      resultsLabel.isHidden = true
    }
  }
  
  func changeFrame(_ frame: CGRect) {
    self.frame = frame
    fadingColorView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    resignAllButton.frame = fadingColorView.frame
    if frame.width < maxWidth {
      header.transform = header.transform.scaledBy(x: 10 / maxWidth, y: 10 / maxHeight)
    } else {
      header.transform = header.transform.scaledBy(x: maxWidth / 10, y: maxHeight / 10)
    }
    header.frame = CGRect(x: 0, y: 4 * (frame.height / maxHeight), width: frame.width * (frame.width / maxWidth), height: 26 * (frame.height / maxHeight))
    inputBackground.frame = CGRect(x: 4 * (frame.width / maxWidth), y: 40 * (frame.height / maxHeight), width: 312 * (frame.width / maxWidth), height: 170 * (frame.height / maxHeight))
    casesLabel.frame = CGRect(x: 4 * (frame.width / maxWidth), y: 2 * (frame.height / maxHeight), width: 148 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    cases.frame = CGRect(x: 230 * (frame.width / maxWidth), y: 2 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    controlsLabel.frame = CGRect(x: 4 * (frame.width / maxWidth), y: 44 * (frame.height / maxHeight), width: 148 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    controls.frame = CGRect(x: 230 * (frame.width / maxWidth), y: 44 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    percentCasesExposedLabel.frame = CGRect(x: 4 * (frame.width / maxWidth), y: 86 * (frame.height / maxHeight), width: 224 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    percentCasesExposed.frame = CGRect(x: 230 * (frame.width / maxWidth), y: 86 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    percentControlsExposedLabel.frame = CGRect(x: 4 * (frame.width / maxWidth), y: 128 * (frame.height / maxHeight), width: 224 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    percentControlsExposed.frame = CGRect(x: 230 * (frame.width / maxWidth), y: 128 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    if !resultsLabel.isHidden {
      resultsLabel.frame = CGRect(x: resultsLabel.frame.origin.x * (frame.width / maxWidth), y: resultsLabel.frame.origin.y * (frame.height / maxHeight), width: resultsLabel.frame.width * (frame.width / maxWidth), height: resultsLabel.frame.height * (frame.height / maxHeight))
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    killThread = true
    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
      self.resultsLabel.frame = CGRect(x: 4, y: self.frame.height - 60, width: 312, height: 60)
      }, completion: {
        (value: Bool) in
        self.resultsLabel.isHidden = true
        self.resultsLabel.text = ""
    })
    return true
  }
  
  func resignAll() {
    var noFirstResponder = true
    for v in inputBackground.subviews {
      if let tf = v as? UITextField {
        if tf.isFirstResponder {
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
      let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
      queue.async {
        self.runComputer((numCases, numControls, pctCasesExposed, pctControlsExposed))
      }
      resultsLabel.isHidden = false
      UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions(), animations: {
        self.resultsLabel.frame = CGRect(x: self.resultsLabel.frame.origin.x, y: self.inputBackground.frame.origin.y + self.inputBackground.frame.height + 8, width: self.resultsLabel.frame.width, height: self.resultsLabel.frame.height)
        }, completion: {
          (value: Bool) in
      })
    }
  }
  
  func runComputer(_ inputs : (Float, Float, Float, Float)) {
    while !killThread {
      let rr = CaseControlSimulationModel.compute(inputs.0, b: inputs.1, c: inputs.2, d: inputs.3)
      DispatchQueue.main.async {
        self.resultsLabel.text = "\(rr.0)% of simulations found a significant relative risk."
      }
      sleep(2)
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
