//
//  ViewController.swift
//  Memory
//
//  Created by Wiktor Lemański on 18/11/2022.
//

import UIKit

class ViewController: UIViewController {

    var lvl = 0
    var isLandscape = false
    @IBOutlet weak var level: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLandscape = UIDevice.current.orientation.isLandscape
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ViewController2
        dest.level = lvl
        dest.isHorizontal = isLandscape
    }

    @IBAction func whichLevel(_ sender: UISegmentedControl) {
        if(level.selectedSegmentIndex == 0){
            lvl = 0
        }else{
            lvl = 1
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        isLandscape =  UIDevice.current.orientation.isLandscape
    }
}

