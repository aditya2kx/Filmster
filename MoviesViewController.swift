//
//  MoviesViewController.swift
//  Filmster
//
//  Created by Aditya Parikh on 9/14/14.
//  Copyright (c) 2014 Aditya Parikh. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {

    @IBOutlet weak var MoviesTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    var moviesDataDictionary = []
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        MoviesTableView.insertSubview(refreshControl, atIndex: 0)
        getLatestMoviesData()
        // Do any additional setup after loading the view.
    }
    
    func refreshData(){
        movieSearchBar.text = ""
        getLatestMoviesData()
        self.refreshControl.endRefreshing()
    }
    
    func getLatestMoviesData(){
        let YourApiKey = "rkruac5vsmgzwwcc6jdgny9a"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=" + YourApiKey
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(RottenTomatoesURLString))

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            if(error == nil){
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.moviesDataDictionary = dictionary["movies"] as NSArray
                self.MoviesTableView.reloadData()
            }else{
                println("network error")
                self.showError()
            }
        })
    }
    
    func showError(){
        
        UIView.animateWithDuration(1.0, animations: {
            // slide down
            self.errorView.alpha = 1
            }) { (complete) -> Void in
                UIView.animateWithDuration(1.0, animations: {
                    // slide down
                    self.errorView.alpha = 0
                })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(countElements(searchText) != 0){
            println(searchText)
            let YourApiKey = "rkruac5vsmgzwwcc6jdgny9a"
            let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=" + YourApiKey + "&q=" + searchText
            let request = NSMutableURLRequest(URL: NSURL.URLWithString(RottenTomatoesURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!))
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
                if(error == nil){
                    let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                    self.moviesDataDictionary = dictionary["movies"] as NSArray
                    self.MoviesTableView.reloadData()
                }else{
                    println("network error")
                    self.showError()
                }
            })
        }else{
            getLatestMoviesData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var moviesCell = MoviesTableView.dequeueReusableCellWithIdentifier("MoviesTableViewCellID") as MoviesTableViewCell
        var movieDictionary = moviesDataDictionary[indexPath.row] as NSDictionary
        var posterURLs = movieDictionary["posters"] as NSDictionary
        var thumbnailURL = posterURLs["thumbnail"] as NSString
        let bigThumbnailURL = thumbnailURL.stringByReplacingOccurrencesOfString("tmb", withString: "det")
        let mpaaRating = movieDictionary["mpaa_rating"] as NSString
                
        var placeHolderImageView = UIImageView()
        placeHolderImageView.setImageWithURL(NSURL(string: thumbnailURL))
        moviesCell.movieTitleLabel.text = movieDictionary["title"] as NSString
        moviesCell.movieDescriptionLabel.text = mpaaRating + " " + (movieDictionary["synopsis"] as NSString)
        moviesCell.movieThumbnailImageView.setImageWithURL(NSURL(string: bigThumbnailURL), placeholderImage: placeHolderImageView.image)
        return moviesCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesDataDictionary.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "movieDetailSegueID")
        {
            // Get reference to the destination view controller
            var movieDetailViewController = segue.destinationViewController as MovieDetailViewController

            let selectedIndexPath = MoviesTableView.indexPathForSelectedRow()!
            var movieDictionary = moviesDataDictionary[selectedIndexPath.row] as NSDictionary
            movieDetailViewController.title = movieDictionary["title"] as NSString
            var posterURLs = movieDictionary["posters"] as NSDictionary
            var thumbnailURL = posterURLs["thumbnail"] as NSString
            movieDetailViewController.movieDetailsText = movieDictionary["synopsis"] as NSString
            movieDetailViewController.moviePosterPlaceHolderURL = thumbnailURL;//.stringByReplacingOccurrencesOfString("tmb", withString: "pro")
            movieDetailViewController.moviePosterURL = thumbnailURL.stringByReplacingOccurrencesOfString("tmb", withString: "org")
        }
    }
}


