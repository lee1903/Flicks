//
//  CellViewController.swift
//  Flicks
//
//  Created by Brian Lee on 1/19/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class CellViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    var titleString: String = ""
    var overviewString: String = ""
    var imageString: String = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var overviewOutlet: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self

        let url = NSURL(string: imageString)
        imageOutlet.setImageWithURL(url!)
        
        let image = imageOutlet.image!
        let colors = image.getColors()
        
        infoView.backgroundColor = colors.backgroundColor
        self.view.backgroundColor = colors.backgroundColor
        titleOutlet.textColor = colors.primaryColor
        overviewOutlet.textColor = colors.secondaryColor
        
        titleOutlet.text = titleString
        overviewOutlet.text = overviewString
        
        overviewOutlet.sizeToFit()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let p = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.frame.size.height + 50)
        //scrollView.setContentOffset(p, animated: true)
        
//        UIView.animateWithDuration(1, delay: 1.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
//            
//            self.scrollView.setContentOffset(p, animated: true)
//            
//            }, completion: { (finished: Bool) -> Void in
//
//        })
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.scrollView.setContentOffset(p, animated: true)
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset.y + scrollView.frame.size.height)
        if (scrollView.contentOffset.y + scrollView.frame.size.height) > 555{
            let alpha = ((scrollView.contentOffset.y + scrollView.frame.size.height) - 555) / 90
            infoView.alpha = alpha
        }
        let alpha = 1.5 - (((scrollView.contentOffset.y + scrollView.frame.size.height) - 372) / 234)
        imageOutlet.alpha = alpha
        
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
