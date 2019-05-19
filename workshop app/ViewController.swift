//
//  ViewController.swift
//  workshop app
//
//  Created by Leo Dion on 5/19/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

struct ValuesStruct {
  var array : [Int]
  
}

class ValuesClass {
  var array : [Int]
  
  init (array: [Int]) {
    self.array = array
  }
}

class ViewController: UIViewController {
  let numbers = [Int]()
  @IBOutlet weak var structLabel : UILabel!
  @IBOutlet weak var classLabel : UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    var stct = ValuesStruct(array: [1,2,3,4,5])
    var cls = ValuesClass(array: [1,2,3,4,5])
    
    var newStct = stct
    newStct.array = [2,4,8]
    
    var newCls = cls
    cls.array = [2,4,8]
    
    structLabel.text = stct.array.description
    classLabel.text = cls.array.description
  }


}

