//
//  CohortSimulationView.swift
//  EpiInfo
//
//  Created by John Copeland on 3/5/15.
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


class CohortSimulationsView: UIView, UITextFieldDelegate {
  
  var fadingColorView = UIImageView()
  var resignAllButton = UIButton()
  var header = UILabel()
  var inputBackground = UIButton()
  var resultsLabel = EpiInfoMultiLineIndentedUILabel()
  var exposedLabel = UIButton()
  var exposed = NumberField()
  var unexposedLabel = UIButton()
  var unexposed = NumberField()
  var percentInExposedLabel = UIButton()
  var percentInExposed = NumberField()
  var percentInUnexposedLabel = UIButton()
  var percentInUnexposed = NumberField()
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
      resignAllButton.addTarget(self, action: #selector(CohortSimulationsView.resignAll), for: .touchUpInside)
      self.addSubview(resignAllButton)
      
      //Screen header
      header = UILabel(frame: CGRect(x: 0, y: 4 * (frame.height / maxHeight), width: frame.width * (frame.width / maxWidth), height: 26 * (frame.height / maxHeight)))
      header.backgroundColor = .clear
      header.textColor = .white
      header.textAlignment = .center
      header.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
      header.text = "Simulate Cohort Study"
      self.addSubview(header)
      
      //Add navy background for input fields
      inputBackground = UIButton(frame: CGRect(x: 4 * (frame.width / maxWidth), y: 40 * (frame.height / maxHeight), width: 312 * (frame.width / maxWidth), height: 170 * (frame.height / maxHeight)))
      inputBackground.backgroundColor = UIColor(red: 3/255.0, green: 36/255.0, blue: 77/255.0, alpha: 1.0)
      inputBackground.layer.masksToBounds = true
      inputBackground.layer.cornerRadius = 8.0
      inputBackground.addTarget(self, action: #selector(CohortSimulationsView.resignAll), for: .touchUpInside)
      self.addSubview(inputBackground)
      
      //Add the NumberField for number of exposed
      exposedLabel = UIButton(frame: CGRect(x: 4 * (frame.width / maxWidth), y: 2 * (frame.height / maxHeight), width: 148 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      exposedLabel.backgroundColor = .clear
      exposedLabel.clipsToBounds = true
      exposedLabel.setTitle("Number Exposed", for: UIControlState())
      exposedLabel.contentHorizontalAlignment = .left
      exposedLabel.titleLabel!.textAlignment = .left
      exposedLabel.titleLabel!.textColor = .white
      exposedLabel.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
      exposedLabel.addTarget(self, action: #selector(CohortSimulationsView.resignAll), for: .touchUpInside)
      inputBackground.addSubview(exposedLabel)
      
      exposed = NumberField(frame: CGRect(x: 230 * (frame.width / maxWidth), y: 2 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      exposed.borderStyle = .roundedRect
      exposed.keyboardType = .numberPad
      exposed.delegate = self
      exposed.returnKeyType = .done
      inputBackground.addSubview(exposed)
      
      //Add the NumberField for number of unexposed
      unexposedLabel = UIButton(frame: CGRect(x: 4 * (frame.width / maxWidth), y: 44 * (frame.height / maxHeight), width: 148 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      unexposedLabel.backgroundColor = .clear
      unexposedLabel.clipsToBounds = true
      unexposedLabel.setTitle("Number Unexposed", for: UIControlState())
      unexposedLabel.contentHorizontalAlignment = .left
      unexposedLabel.titleLabel!.textAlignment = .left
      unexposedLabel.titleLabel!.textColor = .white
      unexposedLabel.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
      unexposedLabel.addTarget(self, action: #selector(CohortSimulationsView.resignAll), for: .touchUpInside)
      inputBackground.addSubview(unexposedLabel)
      
      unexposed = NumberField(frame: CGRect(x: 230 * (frame.width / maxWidth), y: 44 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      unexposed.borderStyle = .roundedRect
      unexposed.keyboardType = .numberPad
      unexposed.delegate = self
      unexposed.returnKeyType = .done
      inputBackground.addSubview(unexposed)
      
      //Add the NumberField for percent in exposed
      percentInExposedLabel = UIButton(frame: CGRect(x: 4 * (frame.width / maxWidth), y: 86 * (frame.height / maxHeight), width: 224 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      percentInExposedLabel.backgroundColor = .clear
      percentInExposedLabel.clipsToBounds = true
      percentInExposedLabel.setTitle("Expected % Exposed with Outcome", for: UIControlState())
      percentInExposedLabel.contentHorizontalAlignment = .left
      percentInExposedLabel.titleLabel!.textAlignment = .left
      percentInExposedLabel.titleLabel!.textColor = .white
      percentInExposedLabel.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
      percentInExposedLabel.titleLabel?.adjustsFontSizeToFitWidth = true
      percentInExposedLabel.addTarget(self, action: #selector(CohortSimulationsView.resignAll), for: .touchUpInside)
      inputBackground.addSubview(percentInExposedLabel)
      
      percentInExposed = NumberField(frame: CGRect(x: 230 * (frame.width / maxWidth), y: 86 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      percentInExposed.borderStyle = .roundedRect
      percentInExposed.keyboardType = .decimalPad
      percentInExposed.delegate = self
      percentInExposed.returnKeyType = .done
      inputBackground.addSubview(percentInExposed)
      
      //Add the NumberField for percent in unexposed
      percentInUnexposedLabel = UIButton(frame: CGRect(x: 4 * (frame.width / maxWidth), y: 128 * (frame.height / maxHeight), width: 224 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      percentInUnexposedLabel.backgroundColor = .clear
      percentInUnexposedLabel.clipsToBounds = true
      percentInUnexposedLabel.setTitle("Expected % Unexposed with Outcome", for: UIControlState())
      percentInUnexposedLabel.contentHorizontalAlignment = .left
      percentInUnexposedLabel.titleLabel!.textAlignment = .left
      percentInUnexposedLabel.titleLabel!.textColor = .white
      percentInUnexposedLabel.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
      percentInUnexposedLabel.titleLabel?.adjustsFontSizeToFitWidth = true
      percentInUnexposedLabel.addTarget(self, action: #selector(CohortSimulationsView.resignAll), for: .touchUpInside)
      inputBackground.addSubview(percentInUnexposedLabel)
      
      percentInUnexposed = NumberField(frame: CGRect(x: 230 * (frame.width / maxWidth), y: 128 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight)))
      percentInUnexposed.borderStyle = .roundedRect
      percentInUnexposed.keyboardType = .decimalPad
      percentInUnexposed.delegate = self
      percentInUnexposed.returnKeyType = .done
      inputBackground.addSubview(percentInUnexposed)
      
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
    exposedLabel.frame = CGRect(x: 4 * (frame.width / maxWidth), y: 2 * (frame.height / maxHeight), width: 148 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    exposed.frame = CGRect(x: 230 * (frame.width / maxWidth), y: 2 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    unexposedLabel.frame = CGRect(x: 4 * (frame.width / maxWidth), y: 44 * (frame.height / maxHeight), width: 148 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    unexposed.frame = CGRect(x: 230 * (frame.width / maxWidth), y: 44 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    percentInExposedLabel.frame = CGRect(x: 4 * (frame.width / maxWidth), y: 86 * (frame.height / maxHeight), width: 224 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    percentInExposed.frame = CGRect(x: 230 * (frame.width / maxWidth), y: 86 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    percentInUnexposedLabel.frame = CGRect(x: 4 * (frame.width / maxWidth), y: 128 * (frame.height / maxHeight), width: 224 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
    percentInUnexposed.frame = CGRect(x: 230 * (frame.width / maxWidth), y: 128 * (frame.height / maxHeight), width: 80 * (frame.width / maxWidth), height: 40 * (frame.height / maxHeight))
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
    
    if exposed.text?.characters.count > 0 && unexposed.text?.characters.count > 0 && percentInExposed.text?.characters.count > 0 && percentInUnexposed.text?.characters.count > 0 {
      let numExposed = (exposed.text! as NSString).floatValue
      let numUnexposed = (unexposed.text! as NSString).floatValue
      let pctExposed = (percentInExposed.text! as NSString).floatValue
      let pctUnexposed = (percentInUnexposed.text! as NSString).floatValue
      
      if pctExposed > 100 {
        percentInExposed.text = ""
        percentInExposed.placeholder = "<=100"
        return
      } else if pctUnexposed > 100 {
        percentInUnexposed.text = ""
        percentInUnexposed.placeholder = "<=100"
        return
      }
      
      killThread = false
      let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
      queue.async {
        self.runComputer((numExposed, numUnexposed, pctExposed, pctUnexposed))
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
      let rr = CohortSimulationModel.compute(inputs.0, b: inputs.1, c: inputs.2, d: inputs.3)
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
