//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Brian Lee on 1/13/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit
import MBProgressHUD
import AFNetworking

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var networkErrorView: UIView!

    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]!
    var endpoint: String!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        
        navItem.titleView = searchBar
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        
        collectionView.insertSubview(refreshControl, atIndex: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        collectionView.backgroundView = UIView()
        collectionView.backgroundView!.addGestureRecognizer(tap)
        
        let refreshtap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "networkErrorRefresh")
        networkErrorView.addGestureRecognizer(refreshtap)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        networkRequest()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        navItem.titleView?.endEditing(true)
    }
    
    func networkErrorRefresh() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        networkRequest()
    }

    
    func networkRequest(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )

        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //NSLog("response: \(responseDictionary)")
                            
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            
                            if self.searchBar.text == ""{
                                self.filteredMovies = self.movies
                            }
                            
                            self.networkErrorView.hidden = true
                            self.collectionView.hidden = false
                            
                            self.collectionView.reloadData()
                    }
                }
                else{
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.networkErrorView.hidden = false
                    self.collectionView.hidden = true
                }
        });
        task.resume()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // Make network request to fetch latest data
        dismissKeyboard()
        networkRequest()
        // Do the following when the network request comes back successfully:
        // Update tableView data source
        self.collectionView.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if let filteredMovies = filteredMovies{
            return filteredMovies.count
        } else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = filteredMovies[indexPath.row]
        let image = movie["poster_path"] as! String
        
        let url = NSURL(string: "https://image.tmdb.org/t/p/w342\(image)")
        cell.alpha = 0
        cell.imageLabel.setImageWithURL(url!)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            cell.alpha = 1
        })
        
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies!.filter({(dataItem: NSDictionary) -> Bool in
                let str = dataItem["title"] as! String
                if str.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        collectionView.reloadData()
    }
    

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        dismissKeyboard()
        self.performSegueWithIdentifier("showDetail", sender: filteredMovies![indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as! CellViewController
        let movie = sender as! NSDictionary
        
        let image = movie["poster_path"] as! String
        
        viewController.imageString = "https://image.tmdb.org/t/p/w342\(image)"
        viewController.titleString = movie["title"] as! String
        viewController.overviewString = movie["overview"] as! String
        
        let rating = movie["vote_average"] as! Double
        let dateString = movie["release_date"] as! String
        let year = dateString.substringWithRange(Range<String.Index>(start: dateString.startIndex.advancedBy(0), end: dateString.startIndex.advancedBy(4)))
        let month = dateString.substringWithRange(Range<String.Index>(start: dateString.startIndex.advancedBy(5), end: dateString.startIndex.advancedBy(7)))
        let day = dateString.substringWithRange(Range<String.Index>(start: dateString.startIndex.advancedBy(8), end: dateString.startIndex.advancedBy(10)))
        let date = "\(month)/\(day)/\(year)"
        
        viewController.dateString = date
        viewController.rating = rating
        
        
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
