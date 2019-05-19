//
//  ViewController.swift
//  workshop app
//
//  Created by Leo Dion on 5/19/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  let numbers = [Int]()
  @IBOutlet weak var structLabel : UILabel!
  @IBOutlet weak var classLabel : UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    structLabel.text = numbers.first!.description
    
  }


}

