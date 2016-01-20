//
//  CellViewController.swift
//  Flicks
//
//  Created by Brian Lee on 1/19/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class CellViewController: UIViewController {
    
    var titleString: String = ""
    var overviewString: String = ""
    
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var overviewOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleOutlet.text = titleString
        overviewOutlet.text = overviewString

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}