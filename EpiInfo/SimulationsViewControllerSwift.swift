//
//  SimulationsViewControllerSwift.swift
//  EpiInfo
//
//  Created by John Copeland on 3/4/15.
//

import UIKit

class SimulationsViewControllerSwift: UIViewController {
  
  var fadingColorView = UIImageView()
  var v1 = UIView()
  var v2 = UIView()
  var customBackButton = UIButton()
  var cohortSimulationView = CohortSimulationsView()
  var casecontrolSimulationView = CaseControlSimulationsView()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let titleViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    titleViewLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
    titleViewLabel.text = "Simulations"
    titleViewLabel.textAlignment = NSTextAlignment.center
    titleViewLabel.textColor = UIColor.white
    titleViewLabel.backgroundColor = UIColor.clear
    self.navigationItem.titleView = titleViewLabel
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      // Change the standard NavigationController "Back" button to an "X"
      customBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
      customBackButton.setImage(UIImage(named: "StAndrewXButtonWhite.png"), for: UIControlState())
      customBackButton.addTarget(self, action: #selector(SimulationsViewControllerSwift.popCurrentViewController), for: .touchUpInside)
      customBackButton.layer.masksToBounds = true
      customBackButton.layer.cornerRadius = 8.0
      customBackButton.setTitle("Back to previous screen", for: UIControlState())
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customBackButton)
      self.navigationItem.hidesBackButton = true
    } else {
      // Change the standard NavigationController "Back" button to an "X"
      customBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
      customBackButton.setImage(UIImage(named: "StAndrewXButtonWhite.png"), for: UIControlState())
      customBackButton.addTarget(self, action: #selector(SimulationsViewControllerSwift.popCurrentViewController), for: .touchUpInside)
      customBackButton.layer.masksToBounds = true
      customBackButton.layer.cornerRadius = 8.0
      customBackButton.setTitle("Back to previous screen", for: UIControlState())
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customBackButton)
      self.navigationItem.hidesBackButton = true
      
      // Add background image
      fadingColorView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - self.navigationController!.navigationBar.frame.height - UIApplication.shared.statusBarFrame.height))
      let frameHeight: Float = Float(self.view.frame.size.height)
      if frameHeight > 500 {
        let pictureHeight = UIImage(named: "iPhone5Background.png")!.size.height
        let pictureWidth = UIImage(named: "iPhone5Background.png")!.size.width
        fadingColorView.image = UIImage(named: "iPhone5Background.png")
      } else {
        let pictureHeight = UIImage(named: "iPhone4Background.png")!.size.height
        let pictureWidth = UIImage(named: "iPhone4Background.png")!.size.width
        fadingColorView.image = UIImage(named: "iPhone4Background.png")
      }
      self.view.addSubview(fadingColorView)
      self.view.sendSubview(toBack: fadingColorView)
      
      // Add and wire up Cohort Study Simulation Button
      v1 = UIView(frame: CGRect(x: CGFloat(sqrtf(800)), y: CGFloat(sqrtf(800)) + 60.0, width: 60, height: 90))
      v1.backgroundColor = UIColor.clear
      self.view.addSubview(v1)
      let cohortButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
      cohortButton.layer.cornerRadius = 10.0
      cohortButton.layer.masksToBounds = true
      cohortButton.addTarget(self, action: #selector(SimulationsViewControllerSwift.cohortButtonTouched), for: .touchUpInside)
      if UIScreen.main.scale > 1.0 {
        cohortButton.setImage(UIImage(named: "SimulateCohort.png"), for: UIControlState())
      } else {
        cohortButton.setImage(UIImage(named: "SimulateCohortNR.png"), for: UIControlState())
      }
      v1.addSubview(cohortButton)
      let label1 = UILabel(frame: CGRect(x: 0, y: 64, width: 60, height: 12))
      let label2 = UILabel(frame: CGRect(x: 0, y: 76, width: 60, height: 14))
      label1.text = "Cohort"
      label2.text = "Study"
      label1.backgroundColor = UIColor.clear
      label2.backgroundColor = UIColor.clear
      label1.textColor = UIColor.white
      label2.textColor = UIColor.white
      label1.textAlignment = NSTextAlignment.center
      label2.textAlignment = NSTextAlignment.center
      label1.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
      label2.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
      v1.addSubview(label1)
      v1.addSubview(label2)
      
      // Add and wire up Case Control Study Simulation Button
      v2 = UIView(frame: CGRect(x: self.view.frame.size.width / 2.0 - 30.0, y: CGFloat(sqrtf(800)) + 60.0, width: 60, height: 90))
      v2.backgroundColor = UIColor.clear
      self.view.addSubview(v2)
      let casecontrolButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
      casecontrolButton.layer.cornerRadius = 10.0
      casecontrolButton.layer.masksToBounds = true
      casecontrolButton.addTarget(self, action: #selector(SimulationsViewControllerSwift.casecontrolButtonTouched), for: .touchUpInside)
      if UIScreen.main.scale > 1.0 {
        casecontrolButton.setImage(UIImage(named: "SimulateCaseControl.png"), for: UIControlState())
      } else {
        casecontrolButton.setImage(UIImage(named: "SimulateCaseControlNR.png"), for: UIControlState())
      }
      v2.addSubview(casecontrolButton)
      let label3 = UILabel(frame: CGRect(x: -8, y: 64, width: 76, height: 12))
      let label4 = UILabel(frame: CGRect(x: 0, y: 76, width: 60, height: 14))
      label3.text = "Case Control"
      label4.text = "Study"
      label3.backgroundColor = UIColor.clear
      label4.backgroundColor = UIColor.clear
      label3.textColor = UIColor.white
      label4.textColor = UIColor.white
      label3.textAlignment = NSTextAlignment.center
      label4.textAlignment = NSTextAlignment.center
      label3.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
      label4.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
      v2.addSubview(label3)
      v2.addSubview(label4)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    //        Commented lines were used to create a screenshot image.
//            let tmpV = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
//    
//            let barView = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.navigationController!.navigationBar.bounds.height))
//            UIGraphicsBeginImageContext(self.navigationController!.navigationBar.bounds.size)
//            self.navigationController!.navigationBar.layer.renderInContext(UIGraphicsGetCurrentContext())
//            let bar = UIGraphicsGetImageFromCurrentImageContext()
//            barView.image = bar
//            UIGraphicsEndImageContext()
//    
//            let screenView = UIImageView(frame: CGRectMake(0, self.navigationController!.navigationBar.bounds.height, self.view.bounds.width, self.view.bounds.height - self.navigationController!.navigationBar.bounds.height + 40))
//            UIGraphicsBeginImageContext(screenView.bounds.size)
//            self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
//            let screen = UIGraphicsGetImageFromCurrentImageContext()
//            screenView.image = screen
//            UIGraphicsEndImageContext()
//    
//            tmpV.addSubview(barView)
//            tmpV.addSubview(screenView)
//    
//            UIGraphicsBeginImageContext(CGSizeMake(self.view.bounds.width, self.view.bounds.height + self.navigationController!.navigationBar.bounds.height));
//            tmpV.layer.renderInContext(UIGraphicsGetCurrentContext())
//            let imageToSave = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            let imageData = UIImagePNGRepresentation(imageToSave)
//            imageData.writeToFile("/Users/zfj4/CodePlex/temp/Simulations5.png", atomically: true)
    //        To here
  }
  
  func cohortButtonTouched() {
    cohortSimulationView = CohortSimulationsView(frame: self.fadingColorView.frame)
    self.cohortSimulationView.changeFrame(CGRect(x: v1.frame.origin.x, y: v1.frame.origin.y, width: 60, height: 60))
    self.view.addSubview(cohortSimulationView)
    
    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
      self.cohortSimulationView.changeFrame(self.fadingColorView.frame)
      }, completion: {
        (value: Bool) in
        self.customBackButton.removeTarget(self, action: "popCurrentViewController", for: .touchUpInside)
        self.customBackButton.addTarget(self, action: "removeCohortView", for: .touchUpInside)
    })
  }
  
  func casecontrolButtonTouched() {
    casecontrolSimulationView = CaseControlSimulationsView(frame: self.fadingColorView.frame)
    self.casecontrolSimulationView.changeFrame(CGRect(x: v2.frame.origin.x, y: v2.frame.origin.y, width: 60, height: 60))
    self.view.addSubview(casecontrolSimulationView)
    
    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
      self.casecontrolSimulationView.changeFrame(self.fadingColorView.frame)
      }, completion: {
        (value: Bool) in
        self.customBackButton.removeTarget(self, action: "popCurrentViewController", for: .touchUpInside)
        self.customBackButton.addTarget(self, action: "removeCasecontrolView", for: .touchUpInside)
    })
  }
  
  func removeCohortView() {
    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
      self.cohortSimulationView.changeFrame(CGRect(x: self.v1.frame.origin.x, y: self.v1.frame.origin.y, width: 60, height: 60))
      }, completion: {
        (value: Bool) in
        self.cohortSimulationView.killThread = true
        self.cohortSimulationView.removeFromSuperview()
        self.customBackButton.removeTarget(self, action: "removeCohortView", for: .touchUpInside)
        self.customBackButton.addTarget(self, action: "popCurrentViewController", for: .touchUpInside)
    })
  }
  
  func removeCasecontrolView() {
    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
      self.casecontrolSimulationView.changeFrame(CGRect(x: self.v2.frame.origin.x, y: self.v2.frame.origin.y, width: 60, height: 60))
      }, completion: {
        (value: Bool) in
        self.casecontrolSimulationView.killThread = true
        self.casecontrolSimulationView.removeFromSuperview()
        self.customBackButton.removeTarget(self, action: "removeCasecontrolView", for: .touchUpInside)
        self.customBackButton.addTarget(self, action: "popCurrentViewController", for: .touchUpInside)
    })
  }
  
  func popCurrentViewController() {
    self.navigationController?.popViewController(animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
