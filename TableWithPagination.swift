//
//  HomeViewController.swift
//  Autonome
//
//  Created by CS-19 on 15/12/16.
//  Copyright © 2016 Admin. All rights reserved.
//


import UIKit

class HiddenCell : UITableViewCell{

	@IBOutlet var hideFullView: UIView!
	@IBOutlet var cellLbl: UILabel!
	@IBOutlet var unhideBtn: UIButton!
	
}

class MainCell : UITableViewCell
{
    @IBOutlet var btnViewAllComment : UIButton!
    @IBOutlet var ProPicImg : UIImageView!
    @IBOutlet var FullPicImg : UIImageView!
    @IBOutlet var lblCom1 : UILabel!
    @IBOutlet var lblCom2 : UILabel!
    @IBOutlet var btnSideMenu : UIButton!
    @IBOutlet var btnLike : UIButton!
    @IBOutlet var btnComment : UIButton!
    @IBOutlet var btnFan : UIButton!
    @IBOutlet var fullView : UIView!
    @IBOutlet var goToProfileBtn: UIButton!
    
    @IBOutlet var totalLikeLbl: UILabel!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var createdDateLbl: UILabel!
	@IBOutlet var imgStatusLbl: UILabel!
    
	@IBOutlet var buttonCommentWidth: NSLayoutConstraint!
	
    @IBOutlet var PlayImg : UIImageView!
}

class CommentCell: UITableViewCell {
    @IBOutlet var lblComment : UILabel!
}

var IsNewPost: Bool = false

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var isExpand : Bool = Bool()
    var indexSection : Int = -1
    
    
    @IBOutlet var homeTbl: UITableView!
	
	@IBOutlet var noDataView: UIView!
	@IBOutlet var noDataLbl: UILabel!
	
    //var allDataArray : NSMutableArray = NSMutableArray()
    
    var kxMenuIndex : Int = Int()
    
    var pageCount = 1
    var pageSize = 10
    var IsFinish = false
    var ShowLoader = false
    
	@IBOutlet var fewerBackBtn: UIButton!
    
    let linearBar: LinearProgressBar = LinearProgressBar()
	
	var refreshControl: UIRefreshControl!
	
	var currentUserid : String = String()


	//MARK:- Viewdidload
	override func viewDidLoad()
    {
        super.viewDidLoad()
		
		self.noDataView.superview?.bringSubview(toFront: self.noDataView)

		currentUserid = UserDefaults.standard.value(forKey: "ID") as! String
		
		let token : String = UserDefaults.standard.value(forKey: "access_token") as! String
		print("This is token : \(token)")
		let header : NSDictionary = UserDefaults.standard.value(forKey: "userHeaderDict") as! NSDictionary
		print("This is header : \(header)")
		
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.refreshPost(notification:)), name: NSNotification.Name(rawValue: "didPostCreated"), object: nil)
		
		refreshControl = UIRefreshControl()
		self.homeTbl.addSubview(refreshControl)
		refreshControl.addTarget(self, action: #selector(self.refreshTable), for: .valueChanged)
        
        homeTbl.tableFooterView = UIView(frame: CGRect.zero)
		
        self.configureLinearProgressBar()
    }
	
	//MARK:- Pull to refresh method
	func refreshTable() {
		
		if !isSeeFewer
		{
			allDataArray.removeAllObjects()
			self.fewerBackBtn.isHidden = true
			
			self.pageCount = 1
			AppUtilities.sharedInstance.showLoader()
			self.GetPostPrivate()
			refreshControl.endRefreshing()
		}
		else
		{
			self.fewerBackBtn.isHidden = false
			refreshControl.endRefreshing()
			self.homeTbl.reloadData()
		}
	}
	
	//MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
		self.noDataView.isHidden = true
        if !isSeeFewer
        {
            //jinal
            if IsNewPost
			{
                self.linearBar.startAnimation()
            }
            
			

			self.fewerBackBtn.isHidden = true
			
			if self.pageCount == 1
			{
				self.pageCount = 1
				allDataArray.removeAllObjects()
				AppUtilities.sharedInstance.showLoader()
				self.GetPostPrivate()
			}
			else
			{
				if refreshableIndex != nil
				{
					self.GetPostPrivateByRefreshcell()
				}
			}
			
			
			
        }
        else
        {
			
			self.fewerBackBtn.isHidden = false
			if seeFewerPostIDarray.count > 0
			{
				self.seeFewerPostCall()
			}
			
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.linearBar.stopAnimation()
    }
    
    
    fileprivate func configureLinearProgressBar() {
        
        linearBar.backgroundColor = UIColor(red:255/255.0, green:205/255.0, blue:104/255.0, alpha:0.4)
        linearBar.progressBarColor = UIColor(red:255/255.0, green:205/255.0, blue:104/255.0, alpha:1.0)
        linearBar.heightForLinearBar = 5
    }
	
	//MARK:- Refresh post method
    func refreshPost (notification: NSNotification) {
        //jinal
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
			
			
            self.linearBar.stopAnimation()
            
            allDataArray.removeAllObjects()
            
            self.fewerBackBtn.isHidden = true
            
			let type : String = UserDefaults.standard.value(forKey: "UserType") as! String
			if type == "1"
            {
				
            }
			self.pageCount = 1
			IsNewPost = false
			AppUtilities.sharedInstance.showLoader()
			self.GetPostPrivate()
        }
    }
	
	

	//MARK:- Get all posts
    func GetPostPrivate()
    {
        if (AppUtilities.sharedInstance.isNetworkRechable())
        {
            var url : NSString = ""
            //let userid : NSString = UserDefaults.standard.value(forKey: "ID") as! NSString
			
            let appendString = NSString.init(string: "Post/GetPostByPageNo?LoginID=\(currentUserid)&pageIndex=\(pageCount)&pageSize=\(pageSize)")
            
            url = BASE_URL.appending(appendString as String) as NSString
            
            print(url)
            let urlString :String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
            
            AppUtilities.sharedInstance.get(request: request, jsonObject: [:], completion: { (success, object) in
                
                DispatchQueue.main.async(execute:{

                    if(success)
                    {
                        print(object!)
                        AppUtilities.sharedInstance.hideLoader()
                    
                        let dict = object as AnyObject
                        let responseDic : NSDictionary = dict as! NSDictionary
                        let msg = responseDic.value(forKey: "Message")
                        if let status = responseDic.value(forKey: "Status")
                        {
                            if(status as! Bool == true)
                            {
                                //let nsarray = responseDic.value(forKey: "Data") as! NSArray
								let arr2: NSMutableArray = NSMutableArray(array:responseDic.value(forKey: "Data") as! [AnyObject])
								let k : GlobalClass = GlobalClass.sharedInstance()
								let nsarray = k.arrayByReplacingNulls(withString: arr2) as NSArray
								
								
								//let nsmutablearray = NSMutableArray(array: nsarray)
                                //self.allDataArray.addObjects(from: responseDic.value(forKey: "Data") as! [Any])
								allDataArray.addObjects(from: nsarray as! [Any])

								for index in 0..<allDataArray.count
								{
									let nsmutabledict = NSMutableDictionary(dictionary: allDataArray.object(at: index) as! NSDictionary)
									if let bool : Bool = nsmutabledict.value(forKey: "isHide") as? Bool
									{
										print(bool)
									}
									else
									{
										let ishide : Bool = false
										nsmutabledict.setValue(ishide, forKey: "isHide")
									}
									allDataArray.replaceObject(at: index, with: nsmutabledict)
								}
								
								//print(self.allDataArray)
								
                                //jinal
                                self.ShowLoader = false
                                if nsarray.count == 0
								{
                                    self.IsFinish = false
                                }
                                else
                                {
                                    self.IsFinish = true
                                }
								
								if allDataArray.count > 0
								{
									self.noDataView.isHidden = true
								}
								else
								{
									self.noDataView.isHidden = false
								}
								
								
                                self.pageCount += 1 //self.pageCount + self.pageSize
								
                                self.homeTbl.reloadData()
                            }
                            else
                            {
                                self.ShowLoader = false
                                self.IsFinish = false
                                AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: msg as! NSString)
                            }
                        }
                    }
                    else
                    {
                        self.ShowLoader = false
                        self.IsFinish = true
                        AppUtilities.sharedInstance.hideLoader()
						AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: internetError)
                    }
                })

            })
        }
    }
    // MARK:- refresh cell api
	func GetPostPrivateByRefreshcell()
	{
		var pagecount : Int = 0
		let intt : Int = (refreshableIndex)!/10
		let flo : Double = Double(Double(refreshableIndex!)/10.0)
		if flo >= Double(intt)
		{
			pagecount = intt + 1
		}
		else
		{
			pagecount = intt
		}
		
		if (AppUtilities.sharedInstance.isNetworkRechable())
		{
			var url : NSString = ""
			//let userid : NSString = UserDefaults.standard.value(forKey: "ID") as! NSString
			
			let appendString = NSString.init(string: "Post/GetPostByPageNo?LoginID=\(currentUserid)&pageIndex=\(pagecount)&pageSize=\(pageSize)")
			
			url = BASE_URL.appending(appendString as String) as NSString
			
			print(url)
			let urlString :String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
			
			let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
			
			AppUtilities.sharedInstance.get(request: request, jsonObject: [:], completion: { (success, object) in
				
				DispatchQueue.main.async(execute:{
					
					if(success)
					{
						print(object!)
						
						let dict = object as AnyObject
						let responseDic : NSDictionary = dict as! NSDictionary
						let msg = responseDic.value(forKey: "Message")
						if let status = responseDic.value(forKey: "Status")
						{
							if(status as! Bool == true)
							{
								let arr2: NSMutableArray = NSMutableArray(array:responseDic.value(forKey: "Data") as! [AnyObject])
								let k : GlobalClass = GlobalClass.sharedInstance()
								let nsarray = k.arrayByReplacingNulls(withString: arr2) as NSArray

								let dummyPageCount : Int = pagecount-1
								let dummyIndex : Int = dummyPageCount * self.pageSize
								var indexes: IndexSet = []
								print(allDataArray.count)
								for index in 0..<10
								{
									let lastIndex : Int = dummyIndex + index
									if allDataArray.count > lastIndex
									{
										indexes.insert(dummyIndex+index)
									}
								}
								print(indexes)
								allDataArray.replaceObjects(at: indexes, with: nsarray as [AnyObject])
								
								
								for index in 0..<allDataArray.count
								{
									let nsmutabledict = NSMutableDictionary(dictionary: allDataArray.object(at: index) as! NSDictionary)
									if let bool : Bool = nsmutabledict.value(forKey: "isHide") as? Bool
									{
										print(bool)
									}
									else
									{
										let ishide : Bool = false
										nsmutabledict.setValue(ishide, forKey: "isHide")
									}
									allDataArray.replaceObject(at: index, with: nsmutabledict)
								}
								
								//jinal
								self.ShowLoader = false
								if nsarray.count == 0
								{
									self.IsFinish = false
								}
								else
								{
									self.IsFinish = true
								}
								
								if allDataArray.count > 0
								{
									self.noDataView.isHidden = true
								}
								else
								{
									self.noDataView.isHidden = false
								}
								
							
								let ind : NSIndexPath = NSIndexPath(item: refreshableIndex!, section: 0)
								let indPaths : [IndexPath] = [ind as IndexPath]
								self.homeTbl.reloadRows(at: indPaths, with: .none)
								
								refreshableIndex = nil

							}
							else
							{
								self.ShowLoader = false
								self.IsFinish = false
								AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: msg as! NSString)
							}
						}
					}
					else
					{
						self.ShowLoader = false
						self.IsFinish = true
						AppUtilities.sharedInstance.hideLoader()
						AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: internetError)
					}
				})
				
			})
		}
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	
	//MARK:-  TableView Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //jinal
//        if !isSeeFewer
//        {
		if(allDataArray.count > 0)
		{
            if !IsFinish && ShowLoader
			{
                return allDataArray.count + 1
            }
            return allDataArray.count
		}
		else
		{
			return 0
		}
		
//        }
//        else
//        {
//            if !IsFinish && ShowLoader {
//                return seeFewerPostArray.count + 1
//            }
//            return seeFewerPostArray.count
//        }
		
    }
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //jinal
        if indexPath.row == allDataArray.count {
			
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "LoadCell", for: indexPath)
            
            cell.selectionStyle = .none
            return cell
        }
		
		if allDataArray.count < 1
		{
			let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "LoadCell", for: indexPath)
			
			cell.selectionStyle = .none
			return cell
		}
		
		let dict : NSDictionary = allDataArray[indexPath.row] as! NSDictionary
//		if self.allDataArray.count < 1
//		{
//			return cell
//		}
		
		let bool : Bool = dict["isHide"] as! Bool
		
		print(bool)
		
		if bool
		{
			let hideCell : HiddenCell = tableView.dequeueReusableCell(withIdentifier: "hiddenCell", for: indexPath) as! HiddenCell
			
			
			hideCell.layer.cornerRadius = 5.0
			hideCell.hideFullView.layer.cornerRadius = 5.0
			hideCell.hideFullView.clipsToBounds = false
			hideCell.hideFullView.layer.shadowOpacity = 0.6
			hideCell.hideFullView.layer.shadowOffset = CGSize(width: 1, height: 1)
			hideCell.hideFullView.layer.shadowColor = UIColor.lightGray.cgColor
			hideCell.hideFullView.layer.shadowRadius = 1.0
			hideCell.selectionStyle = UITableViewCellSelectionStyle.none
			
			
			if (dict["Username"] != nil)
			{
				let userName : String = (dict["Username"] as! String)
				
				var string : String = String()
				var FinalString : NSMutableAttributedString = NSMutableAttributedString()
				
				string = String.localizedStringWithFormat("You wan't see %1$@'s post",userName)
				FinalString =  NSMutableAttributedString(string: string)
				let attributeusername = (string as NSString).range(of: userName)
				FinalString.setAttributes([ NSForegroundColorAttributeName: UIColor(red: CGFloat(76.0 / 255.0), green: CGFloat(159.0 / 255.0), blue: CGFloat(255.0 / 255.0), alpha: CGFloat(1.0))], range: attributeusername)
				
				hideCell.cellLbl.attributedText = FinalString
			}
			
			hideCell.unhideBtn.tag = indexPath.row
			hideCell.unhideBtn.addTarget(self, action: #selector(unhideThisPostCall(sender:)), for: .touchUpInside)
			
			return hideCell
		}
		else
		{
			let cell : MainCell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell

			cell.layer.cornerRadius = 5.0
			cell.fullView.layer.cornerRadius = 5.0
			cell.fullView.clipsToBounds = false
			cell.fullView.layer.shadowOpacity=0.6
			cell.fullView.layer.shadowOffset = CGSize(width: 1, height: 1)
			cell.fullView.layer.shadowColor = UIColor.lightGray.cgColor
			cell.fullView.layer.shadowRadius = 1.0
			cell.selectionStyle = UITableViewCellSelectionStyle.none
			
			cell.ProPicImg.layer.cornerRadius = 23.0
//			cell.ProPicImg.clipsToBounds = true
			cell.ProPicImg.layer.masksToBounds = true
			cell.FullPicImg.layer.cornerRadius = 4.0
			cell.FullPicImg.clipsToBounds = true
            
            KxMenu.dismiss()
			
			// get all data from dictionary........
			var isUserLike : String = String()
			var userName : String = String()
			var createdDate : String = String()
			var comments : String = String()
			var totalLike : String = String()
						
			let ImgUrl : String = (dict.value(forKey: "FileName")) as! String
			let userID : String = dict["UserID"] as! String
            
            if (dict["MultiMediaType"] as! String).caseInsensitiveCompare("video") == ComparisonResult.orderedSame {
                cell.PlayImg.isHidden = false
            }
            else {
                cell.PlayImg.isHidden = true
            }
						
			cell.FullPicImg.sd_setImage(with: NSURL(string: ImgUrl) as URL!, placeholderImage: UIImage(named: "home_gallery_default"))
			
			if (dict["Username"] != nil)
			{
				userName = (dict["Username"] as! String)
				cell.usernameLbl.text = userName
			}
			if (dict["UploadTimeDiff"] != nil)
			{
				createdDate = (dict["UploadTimeDiff"] as! String)
				
				cell.createdDateLbl.text = createdDate
			}
			if (dict["Comment"] != nil)
			{
				comments = (dict["Comment"] as! String)
				cell.imgStatusLbl.text = comments
			}
			if (dict["TotalLike"] != nil)
			{
				totalLike = (dict["TotalLike"] as! String)
				
				if Int(totalLike)! < 2
				{
					cell.totalLikeLbl.text = "\(totalLike) like"
				}
				else
				{
					cell.totalLikeLbl.text = "\(totalLike) likes"
				}
			}
			
			// show only in private account
			let type : String = UserDefaults.standard.value(forKey: "UserType") as! String
			if type == "1"
			{
				let id : String = dict["UserID"] as! String
				
				if (currentUserid != id)
				{
					cell.btnFan.isHidden = true
				}
				else
				{
					cell.btnFan.isHidden = true
				}
				
				if (dict["IsUserLike"] != nil)
				{
					isUserLike = (dict["IsUserLike"] as! String)
					cell.btnLike.tag = indexPath.row
					
					if (isUserLike == "1")
					{
						cell.btnLike.setImage(UIImage(named:"like"), for: .normal)
					}
					else
					{
						cell.btnLike.setImage(UIImage(named:"unlike"), for: .normal)
					}
					
					cell.btnLike.addTarget(self, action: #selector(clkLike(sender:)), for: .touchUpInside)
				}
				let isFriend : String = dict["IsFriend"] as! String
				if isFriend == "1"
				{
					cell.btnFan.setImage(UIImage(named:"a_fan_btn_white"), for: .normal)
				}
				else
				{
					cell.btnFan.setImage(UIImage(named:"add_fan_btn_white"), for: .normal)
				}
				
				cell.btnSideMenu.tag = indexPath.row
				cell.btnSideMenu.addTarget(self, action: #selector(clkMenu1(sender:)), for: .touchUpInside)
				
				if userID == currentUserid
				{
					cell.btnComment.isHidden = true
					cell.buttonCommentWidth.constant = 0.0
				}
				else
				{
					cell.buttonCommentWidth.constant = 40.0
					cell.btnComment.isHidden = false
					cell.btnComment.tag = indexPath.row
					cell.btnComment.addTarget(self, action: #selector(commentBtnTapped(sender:)), for: .touchUpInside)
				}
				
			}
			else
			{
				cell.btnLike.isHidden = true
				cell.btnFan.isHidden = true
				cell.btnSideMenu.isHidden = true
				cell.btnComment.isHidden = true
			}
			
			cell.goToProfileBtn.tag = indexPath.row
			cell.goToProfileBtn.addTarget(self, action: #selector(goToProfileBtnTapped(sender:)), for: .touchUpInside)
			
			let totalComment = dict["TotalComment"] as! String
			
			if Int(totalComment)! > 0
			{
				cell.btnViewAllComment.setTitle("View all \(totalComment) comments", for: .normal)
			}
			else
			{
				cell.btnViewAllComment.setTitle("Comments", for: .normal)
			}
			cell.btnViewAllComment.tag = indexPath.row
			cell.btnViewAllComment.addTarget(self, action: #selector(viewAllCommentBtnTapped(sender:)), for: .touchUpInside)
			
			let dateComponentsFormatter = DateComponentsFormatter()
			dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
			dateComponentsFormatter.maximumUnitCount = 1
			dateComponentsFormatter.unitsStyle = .full
			
			let createDate = dict["CreateDate"] as! String
			let formatter = DateFormatter()
			var stringFromDate : String = String()
			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
			formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
			
			if let dateFromString = formatter.date(from: createDate)
			{
				stringFromDate = dateComponentsFormatter.string(from: dateFromString , to: Date())!  // "1 month, 2 days, 11 hours"
				cell.createdDateLbl.text = "\(stringFromDate) ago"
			}
			
			let actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:0,y:0, width: 10, height: 10)) as UIActivityIndicatorView
			actInd.center = self.view.center
			actInd.hidesWhenStopped = true
			actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
			cell.ProPicImg.addSubview(actInd)
			actInd.startAnimating()
			
			
			if let userimg : String = dict["ProfileImage"] as? String
			{
				cell.ProPicImg.sd_setImage(with: NSURL(string: userimg) as URL!, placeholderImage: UIImage(named: "default_user_img"))
				
				/*
				cell.ProPicImg.sd_setImage(with: NSURL(string: userimg) as URL!, placeholderImage: UIImage(named: "Circled User Male-100"), completed: { (success) in
				actInd.removeFromSuperview()
				})*/
			}
			else
			{
				cell.ProPicImg.image = UIImage(named: "default_user_img")
			}
			
			/*
			if let userimg : String = dict["ProfileImage"] as? String
			{
				cell.ProPicImg.sd_setImage(with: NSURL(string: userimg) as URL!, placeholderImage: UIImage(named: "Circled User Male-100"))
			}
			else
			{
				cell.ProPicImg.image = UIImage(named: "default_user_img")
			}
			*/
		
			
			if let lastcommentDict : NSDictionary = dict.value(forKey: "LastComment") as? NSDictionary
			{
				
				if let lastComment : String = lastcommentDict["Comment"] as? String
				{
					let username : String = lastcommentDict["Username"] as! String
					
					var string : String = String()
					var FinalString : NSMutableAttributedString = NSMutableAttributedString()
					
					string = String.localizedStringWithFormat("%1$@ : %2$@",username, lastComment)
					FinalString =  NSMutableAttributedString(string: string)
					let attributeusername = (string as NSString).range(of: username)
					let attributecomments = (string as NSString).range(of: lastComment)
					FinalString.setAttributes([ NSForegroundColorAttributeName: UIColor.black], range: attributeusername)
					FinalString.setAttributes([ NSForegroundColorAttributeName: UIColor.gray], range: attributecomments)
					
					cell.lblCom1.attributedText = FinalString
				}
			}
			else
			{
				cell.lblCom1.text = ""
			}
			return cell
		}
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
		if(allDataArray.count > 0)
		{
			//jinal
			if indexPath.row == allDataArray.count {
				return 44.0
			}
			let dict : NSDictionary = allDataArray[indexPath.row] as! NSDictionary
			
			let bool : Bool = dict["isHide"] as! Bool
			
			if bool
			{
				return 40.0
			}
			else
			{
				if (UIDevice.current.userInterfaceIdiom == .pad) {
					return 577
					//return (UIScreen.main.bounds.height/2)
				}
				else
				{
					return (UIScreen.main.bounds.width - 32) + 133
				}
//                return (((UIScreen.main.bounds.width - 32) * 120) / 143) + 133
//				return 329.0
			}
			
		}
		else
		{
			return 0
		}
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //jinal
        if indexPath.row < allDataArray.count
		{
            
            if allDataArray.count > 0
			{
				let dict : NSDictionary = allDataArray[indexPath.row] as! NSDictionary
				let hidebool : Bool = dict["isHide"] as! Bool
				
				if !hidebool
				{
					refreshableIndex = indexPath.row
					
					let Obj: PostDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
					Obj.postDetailID = Int(dict["ID"] as! String)!
					Obj.isShowAdd = true
					self.navigationController!.pushViewController(Obj, animated: true)
				}
            }
        }
    }
	
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if allDataArray.count > 0
        {
            if indexPath.row == allDataArray.count - 1
            {
                //jinal
                if IsFinish
                {
                    IsFinish = false
                    ShowLoader = true
                    tableView.reloadData()
                    self.GetPostPrivate()
                }
            }
        }
    }
	
    //MARK:- view All Comment Button Tapped
	func viewAllCommentBtnTapped(sender : UIButton)  {
		
		if sender.tag < allDataArray.count
		{
			
			if allDataArray.count > 0
			{
				
				refreshableIndex = sender.tag

				let Obj: PostDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
				print(allDataArray[sender.tag])
				Obj.postDetailID = Int((allDataArray[sender.tag] as! NSDictionary).value(forKey: "ID") as! String)!
				Obj.isShowAdd = true
				self.navigationController!.pushViewController(Obj, animated: true)
			}
		}
		
	}
	
    //MARK:- Comment btn Method
    func commentBtnTapped(sender : UIButton)  {
		
		let dict1: NSDictionary = allDataArray[sender.tag] as! NSDictionary
		let messageView: MessageViewController = MessageViewController()
		messageView.userDict = NSMutableDictionary(dictionary:["userid": UserDefaults.standard.value(forKey: "ID") as! String, "contactname": UserDefaults.standard.value(forKey: "username") as! String])
		messageView.receiverDict = NSMutableDictionary(dictionary:["toId": dict1["UserID"] as! String, "contactname": dict1["Username"] as! String, "profilePic": dict1["ProfileImage"] as! String])
		self.tabBarController?.navigationController?.pushViewController(messageView, animated: true)
		
    }
    
    //MARK:- Go to profile btn Method
    func goToProfileBtnTapped(sender : UIButton)  {
        
		//let userid : String = UserDefaults.standard.value(forKey: "ID") as! String
		let postDetailDict : NSDictionary = allDataArray[sender.tag] as! NSDictionary
		
		let id : String = postDetailDict["UserID"] as! String
		
		if (currentUserid != id)
		{
			let Obj: OtherUserProfile = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfile") as! OtherUserProfile
			Obj.otherUserId = Int(id)
			self.navigationController!.pushViewController(Obj, animated: true)
		}
        else
        {
            let Obj: myProfileController = self.storyboard!.instantiateViewController(withIdentifier: "myProfileController") as! myProfileController
            self.navigationController!.pushViewController(Obj, animated: true)
        }
    }
    
    //MARK:- Like Method
     func clkLike(sender:UIButton)
     {
        if allDataArray.count < 1
		{
			return
		}
		
        AppUtilities.sharedInstance.showLoader()
        
        if (AppUtilities.sharedInstance.isNetworkRechable())
        {
            var url : NSString = ""
            
            let status : String = ((allDataArray[sender.tag] as! NSDictionary).value(forKey: "IsUserLike")) as! String
            let postid : String = ((allDataArray[sender.tag] as! NSDictionary).value(forKey: "ID")) as! String
            //let userid : NSString = UserDefaults.standard.value(forKey: "ID") as! NSString
            
            if (status == "1")
            {
                let appendString = NSString.init(string: "Like/UnlikePost?postID=\(postid)&userID=\(currentUserid)")
                url = BASE_URL.appending(appendString as String) as NSString
                
            }
            else
            {
                let appendString = NSString.init(string: "Like/LikePost?postID=\(postid)&userID=\(currentUserid)")
                url = BASE_URL.appending(appendString as String) as NSString
                
            }
            
            print(url)
            let urlString :String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let request = NSMutableURLRequest(url : URL(string: urlString)!)
            
            AppUtilities.sharedInstance.get(request : request, jsonObject: [:], completion: { (success, object) in
                
                DispatchQueue.main.async(execute: {

					if(success)
					{
						//print(object!)
						AppUtilities.sharedInstance.hideLoader()
						
						let dict = object as AnyObject
						let responseDic : NSDictionary = dict as! NSDictionary
						let msg = responseDic.value(forKey: "Message")
						if let status = responseDic.value(forKey: "Status")
						{
							if(status as! Bool == true)
							{
								
								let nsmutabledict = NSMutableDictionary(dictionary: allDataArray.object(at: sender.tag) as! NSDictionary)
								let bool : String = nsmutabledict.value(forKey: "IsUserLike") as! String
								if bool == "0"
								{
									nsmutabledict.setValue("1", forKey: "IsUserLike")
									allDataArray.replaceObject(at: sender.tag, with: nsmutabledict)
								}
								else
								{
									nsmutabledict.setValue("0", forKey: "IsUserLike")
									allDataArray.replaceObject(at: sender.tag, with: nsmutabledict)
								}
								self.homeTbl.reloadData()
								
								/*
								allDataArray.removeAllObjects()
								self.pageCount = 1
								
								if !isSeeFewer
								{
									self.GetPostPrivate()
								}
								else
								{
									self.seeFewerPostCall()
								}
								*/
							}
							else
							{
								AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: msg as! NSString)
							}
						}
					}
					else
					{
						AppUtilities.sharedInstance.hideLoader()
						AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: internetError)
					}
                })

            })
        }
     }

    //MARK:- SideMenu Method
    func clkMenu1(sender:UIButton) {
		
		if 0 == 0 //!isSeeFewer
		{
			kxMenuIndex = sender.tag
			
			var MenuArray : NSArray = NSArray()
			
			let userID : String = (allDataArray[kxMenuIndex] as! NSDictionary)["UserID"] as! String
			
			if userID != currentUserid
			{
				if ((((allDataArray[sender.tag] as! NSDictionary).value(forKey: "IsBlock")) as! String) == "1")
				{
					MenuArray = [KxMenuItem.init("Report", image:nil, target: self, action: #selector(self.pushMenu)) ,
					             //KxMenuItem.init("Unblock", image: nil, target: self, action: #selector(self.pushMenu)),
					             KxMenuItem.init("Hide this post", image: nil, target: self, action: #selector(self.pushMenu)),
					             KxMenuItem.init("See fewer posts like this", image: nil, target: self, action: #selector(self.pushMenu)),
					             KxMenuItem.init("Copy the profile web address", image: nil, target: self, action: #selector(self.pushMenu))]
				}
				else
				{
					MenuArray = [KxMenuItem.init("Report", image:nil, target: self, action: #selector(self.pushMenu)) ,
					             KxMenuItem.init("Block", image: nil, target: self, action: #selector(self.pushMenu)),
					             KxMenuItem.init("Hide this post", image: nil, target: self, action: #selector(self.pushMenu)),
					             KxMenuItem.init("See fewer posts like this", image: nil, target: self, action: #selector(self.pushMenu)),
					             KxMenuItem.init("Copy the profile web address", image: nil, target: self, action: #selector(self.pushMenu))]
				}
			}
			else
			{
				MenuArray = [KxMenuItem.init("Hide this post", image: nil, target: self, action: #selector(self.pushMenu)),
				             KxMenuItem.init("See fewer posts like this", image: nil, target: self, action: #selector(self.pushMenu)),
				             KxMenuItem.init("Copy the profile web address", image: nil, target: self, action: #selector(self.pushMenu))]
			}
			
			
			
			let ind : NSIndexPath = NSIndexPath(item: sender.tag, section: 0)
			let cell : MainCell = homeTbl.cellForRow(at: ind as IndexPath) as! MainCell
			let frm : CGRect = CGRect(x: 30 , y: sender.frame.origin.y + 35, width: 0, height: 0)
			KxMenu.setTintColor(UIColor.lightGray)
			
			KxMenuItem.setAccessibilityValue(String(sender.tag))
			KxMenu.show(in: cell.fullView, from: frm, menuItems: MenuArray as! [KxMenuItem])
		}
    }
	
	//MARK:- Open toggle menu
    func pushMenu(_ sender: Any)
    {
        let item1 = (sender as! KxMenuItem)
		
		if (item1.title == "Report")
		{
			let ImgUrl : String = (((allDataArray[kxMenuIndex] as! NSDictionary).value(forKey: "FileName")) as! String)
			
			let Obj: Create_Report_View_Controller = self.storyboard?.instantiateViewController(withIdentifier: "Create_Report_View_Controller") as! Create_Report_View_Controller
			Obj.imgURL = ImgUrl
			self.navigationController!.pushViewController(Obj, animated: true)
		}
		else if (item1.title == "Block" || item1.title == "Unblock")
		{
			let ind : NSIndexPath = NSIndexPath(item: kxMenuIndex, section: 0)
			let cell : MainCell = self.homeTbl.cellForRow(at: ind as IndexPath) as! MainCell
			cell.btnSideMenu.isUserInteractionEnabled = false
			
			self.blockApiCall()
		}
		else if (item1.title == "Hide this post")
		{
			self.hideThisPostCall()
		}
		else if (item1.title == "See fewer posts like this")
		{
			isSeeFewer = true
			let Obj: HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
			self.navigationController!.pushViewController(Obj, animated: true)
			
			let postid : String = (((allDataArray[kxMenuIndex] as! NSDictionary).value(forKey: "ID")) as! String)
			seeFewerPostIDarray.append(Int(postid)!)
		}
		else if (item1.title == "Copy the profile web address")
		{
			let postid : String = (((allDataArray[kxMenuIndex] as! NSDictionary).value(forKey: "UserID")) as! String)

			let copyString : String = "http://demo40.enextlayer.com/UserInformation/ProfileByID/\(postid)"
			//let copyString = "Vipul thummar"
			let pasteBoard = UIPasteboard.general
			pasteBoard.string = copyString
		}
	}
	
	//MARK:- Block api call
    func blockApiCall()
    {
        //AppUtilities.sharedInstance.showLoader()
		
        if (AppUtilities.sharedInstance.isNetworkRechable())
        {
            var url : NSString = ""
            
            let postid : String = (((allDataArray[kxMenuIndex] as! NSDictionary).value(forKey: "ID")) as! String)
            //let userid : NSString = UserDefaults.standard.value(forKey: "ID") as! NSString
            
            if ((((allDataArray[kxMenuIndex] as! NSDictionary).value(forKey: "IsBlock")) as! String) == "1")
            {
                let appendString = NSString.init(string: "Block/UnBlockPost?postID=\(postid)&userID=\(currentUserid)")
                url = BASE_URL.appending(appendString as String) as NSString
                
            }
            else
            {
                let appendString = NSString.init(string: "Block/BlockPost?postID=\(postid)&userID=\(currentUserid)")
                url = BASE_URL.appending(appendString as String) as NSString
                
            }
            
            print(url)
            let urlString :String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let request = NSMutableURLRequest(url : URL(string: urlString)!)
            
            AppUtilities.sharedInstance.get(request : request, jsonObject: [:], completion: { (success, object) in
                
                DispatchQueue.main.async(execute: {

					if(success)
					{
						//print(object!)
						
						
						let dict = object as AnyObject
						let responseDic : NSDictionary = dict as! NSDictionary
						let msg = responseDic.value(forKey: "Message")
						if let status = responseDic.value(forKey: "Status")
						{
							if(status as! Bool == true)
							{
								let ind : NSIndexPath = NSIndexPath(item: self.kxMenuIndex, section: 0)
								let cell : MainCell = self.homeTbl.cellForRow(at: ind as IndexPath) as! MainCell
								cell.btnSideMenu.isUserInteractionEnabled = true
								
								let nsmutabledict = NSMutableDictionary(dictionary: allDataArray.object(at: self.kxMenuIndex) as! NSDictionary)
								let bool : String = nsmutabledict.value(forKey: "IsBlock") as! String
								if bool == "0"
								{
									nsmutabledict.setValue("1", forKey: "IsBlock")
									allDataArray.replaceObject(at: self.kxMenuIndex, with: nsmutabledict)
								}
								else
								{
									nsmutabledict.setValue("0", forKey: "IsBlock")
									allDataArray.replaceObject(at: self.kxMenuIndex, with: nsmutabledict)
								}
								self.homeTbl.reloadData()
								
//								allDataArray.removeAllObjects()
//								self.pageCount = 1
//								self.GetPostPrivate()
							}
							else
							{
								//AppUtilities.sharedInstance.hideLoader()
								AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: msg as! NSString)
							}
						}
						else
						{
							//AppUtilities.sharedInstance.hideLoader()
						}
					}
					else
					{
						//AppUtilities.sharedInstance.hideLoader()
						AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: internetError)
					}
                })

            })
        }
        
    }
	
	//MARK:- Hide post method
    func hideThisPostCall()
    {
		let nsmutabledict = NSMutableDictionary(dictionary: allDataArray.object(at: kxMenuIndex) as! NSDictionary)
		if let bool : Bool = nsmutabledict.value(forKey: "isHide") as? Bool
		{
			print(bool)
			
			let ishide : Bool = true
			nsmutabledict.setValue(ishide, forKey: "isHide")
			allDataArray.replaceObject(at: kxMenuIndex, with: nsmutabledict)
		}
		
       // self.allDataArray.removeObject(at: kxMenuIndex)
        self.homeTbl.reloadData()
		
		self.hideApiCall()
		
    }
	
	//MARK:- Unhide post method
	func unhideThisPostCall(sender:UIButton)
	{
		let nsmutabledict = NSMutableDictionary(dictionary: allDataArray.object(at: sender.tag) as! NSDictionary)
		if let bool : Bool = nsmutabledict.value(forKey: "isHide") as? Bool
		{
			print(bool)
			
			let ishide : Bool = false
			nsmutabledict.setValue(ishide, forKey: "isHide")
			allDataArray.replaceObject(at: sender.tag, with: nsmutabledict)
		}
		self.homeTbl.reloadData()
		
		self.unhideApiCall()
	}
	
	//MARK:- hide api call
	func hideApiCall()
	{
		//Post/HidePost?postId={postId}&userId={userId}
		
		AppUtilities.sharedInstance.showLoader()
		
		if (AppUtilities.sharedInstance.isNetworkRechable())
		{
			var url : NSString = ""
			
			let postid : String = (((allDataArray[kxMenuIndex] as! NSDictionary).value(forKey: "ID")) as! String)
			//let userid : NSString = UserDefaults.standard.value(forKey: "ID") as! NSString
			
			let appendString = NSString.init(string: "Post/HidePost?postId=\(postid)&userId=\(currentUserid)")
			url = BASE_URL.appending(appendString as String) as NSString
			
			
			print(url)
			let urlString :String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
			let request = NSMutableURLRequest(url : URL(string: urlString)!)
			
			AppUtilities.sharedInstance.get(request : request, jsonObject: [:], completion: { (success, object) in
				DispatchQueue.main.async(execute:{
					
					if(success)
					{
						print(object!)
						AppUtilities.sharedInstance.hideLoader()
						
						let dict = object as AnyObject
						let responseDic : NSDictionary = dict as! NSDictionary
						let msg = responseDic.value(forKey: "Message")
						if let status = responseDic.value(forKey: "Status")
						{
							if(status as! Bool == true)
							{
								
							}
							else
							{
								AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: msg as! NSString)
							}
						}
					}
					else
					{
						
						AppUtilities.sharedInstance.hideLoader()
						AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: internetError)
					}
				})
			})
		}

	}
	
	//MARK:- unhide api call
	func unhideApiCall()
	{
		//Post/UndoHidePost?postId={postId}&userId={userId}
		
		AppUtilities.sharedInstance.showLoader()
		
		if (AppUtilities.sharedInstance.isNetworkRechable())
		{
			var url : NSString = ""
			
			let postid : String = (((allDataArray[kxMenuIndex] as! NSDictionary).value(forKey: "ID")) as! String)
			//let userid : NSString = UserDefaults.standard.value(forKey: "ID") as! NSString
			
			let appendString = NSString.init(string: "Post/UndoHidePost?postId=\(postid)&userId=\(currentUserid)")
			url = BASE_URL.appending(appendString as String) as NSString
			
			
			print(url)
			let urlString :String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
			let request = NSMutableURLRequest(url : URL(string: urlString)!)
			
			AppUtilities.sharedInstance.get(request : request, jsonObject: [:], completion: { (success, object) in
				DispatchQueue.main.async(execute:{
					
					if(success)
					{
						print(object!)
						AppUtilities.sharedInstance.hideLoader()
						
						let dict = object as AnyObject
						let responseDic : NSDictionary = dict as! NSDictionary
						let msg = responseDic.value(forKey: "Message")
						if let status = responseDic.value(forKey: "Status")
						{
							if(status as! Bool == true)
							{
								
							}
							else
							{
								AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: msg as! NSString)
							}
						}
					}
					else
					{
						
						AppUtilities.sharedInstance.hideLoader()
						AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: internetError)
					}
				})
			})
		}
		
	}
	/*
	//MARK:- See fewer post call
    func seeFewerPostCall()
    {
        AppUtilities.sharedInstance.showLoader()
		
        if (AppUtilities.sharedInstance.isNetworkRechable())
        {
            var url : NSString = ""
            
            //let postid : String = (((allDataArray[kxMenuIndex] as! NSDictionary).value(forKey: "ID")) as! String)
			let postid : Int = seeFewerPostIDarray.last!
			
            let appendString = NSString.init(string: "Post/SeeFewerPostLike?PostID=\(postid)&LoginID=\(currentUserid)")
            url = BASE_URL.appending(appendString as String) as NSString
            
            
            print(url)
            let urlString :String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let request = NSMutableURLRequest(url : URL(string: urlString)!)
            
            AppUtilities.sharedInstance.get(request : request, jsonObject: [:], completion: { (success, object) in
				DispatchQueue.main.async(execute:{

					if(success)
					{
						print(object!)
						AppUtilities.sharedInstance.hideLoader()
						
						let dict = object as AnyObject
						let responseDic : NSDictionary = dict as! NSDictionary
						let msg = responseDic.value(forKey: "Message")
						
						if let status = responseDic.value(forKey: "Status")
						{
							
							if(status as! Bool == true)
							{
								allDataArray.removeAllObjects()
								
								if ((responseDic.value(forKey: "Data") as! NSArray).count > 0)
								{
									
									let arr2: NSMutableArray = NSMutableArray(array:responseDic.value(forKey: "Data") as! [AnyObject])
									let k : GlobalClass = GlobalClass.sharedInstance()
									let nsarray = k.arrayByReplacingNulls(withString: arr2) as NSArray
									
									allDataArray.addObjects(from: nsarray as! [Any])
									
									for index in 0..<allDataArray.count
									{
										let nsmutabledict = NSMutableDictionary(dictionary: allDataArray.object(at: index) as! NSDictionary)
										if let bool : Bool = nsmutabledict.value(forKey: "isHide") as? Bool
										{
											print(bool)
										}
										else
										{
											let ishide : Bool = false
											nsmutabledict.setValue(ishide, forKey: "isHide")
										}
										allDataArray.replaceObject(at: index, with: nsmutabledict)
										
									}
									
									self.homeTbl.reloadData()
								}
								else
								{
									self.homeTbl.reloadData()
									AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: "There are no fewer posts.")
								}
							}
							else
							{
								AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: msg as! NSString)
							}
						}
					}
					else
					{
						
						AppUtilities.sharedInstance.hideLoader()
						AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: internetError)
					}
				})
            })
        }
    }
	*/
	func seeFewerPostCall()
	{
		AppUtilities.sharedInstance.showLoader()
		
		if (AppUtilities.sharedInstance.isNetworkRechable())
		{
			var url : NSString = ""
			let postid : Int = seeFewerPostIDarray.last!
			
			let appendString = NSString.init(string: "Post/SeeFewerPostLike?PostID=\(postid)&LoginID=\(currentUserid)")
			url = BASE_URL.appending(appendString as String) as NSString
			
			print(url)
			let urlString :String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
			let request = NSMutableURLRequest(url : URL(string: urlString)!)
			
			AppUtilities.sharedInstance.get(request : request, jsonObject: [:], completion: { (success, object) in
				DispatchQueue.main.async(execute:{
					
					if(success)
					{
						print(object!)
						AppUtilities.sharedInstance.hideLoader()
						
						let dict = object as AnyObject
						let responseDic : NSDictionary = dict as! NSDictionary
						let msg = responseDic.value(forKey: "Message")
						
						if let status = responseDic.value(forKey: "Status")
						{
							
							if(status as! Bool == true)
							{
								allDataArray.removeAllObjects()
								
								if ((responseDic.value(forKey: "Data") as! NSArray).count > 0)
								{
									
									let arr2: NSMutableArray = NSMutableArray(array:responseDic.value(forKey: "Data") as! [AnyObject])
									let k : GlobalClass = GlobalClass.sharedInstance()
									let nsarray = k.arrayByReplacingNulls(withString: arr2) as NSArray
									
									allDataArray.addObjects(from: nsarray as! [Any])
									
									for index in 0..<allDataArray.count
									{
										let nsmutabledict = NSMutableDictionary(dictionary: allDataArray.object(at: index) as! NSDictionary)
										if let bool : Bool = nsmutabledict.value(forKey: "isHide") as? Bool
										{
											print(bool)
										}
										else
										{
											let ishide : Bool = false
											nsmutabledict.setValue(ishide, forKey: "isHide")
										}
										allDataArray.replaceObject(at: index, with: nsmutabledict)
										
									}
									
									//jinal
									if allDataArray.count > 0
									{
										self.noDataView.isHidden = true
									}
									else
									{
										self.noDataView.isHidden = false
									}
									
									self.homeTbl.reloadData()
								}
								else
								{
									//jinal
									if allDataArray.count > 0
									{
										self.noDataView.isHidden = true
									}
									else
									{
										self.noDataView.isHidden = false
									}
									self.homeTbl.reloadData()
									//									AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: "There are no fewer posts.")
								}
							}
							else
							{
								AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: msg as! NSString)
							}
						}
					}
					else
					{
						
						AppUtilities.sharedInstance.hideLoader()
						AppUtilities.sharedInstance.showAlert(title: App_Title as NSString, msg: internetError)
					}
				})
			})
		}
	}

	
	//MARK:- fewer back button method
	@IBAction func fewerBackBtnTapped(_ sender: Any)
	{
		seeFewerPostIDarray.removeLast()
		
		if seeFewerPostIDarray.count > 0
		{
			isSeeFewer = true
			self.fewerBackBtn.isHidden = false
		}
		else
		{
			isSeeFewer = false
			self.fewerBackBtn.isHidden = true
		}
		
		self.navigationController!.popViewController(animated: true)
	}
	
    /*@IBAction func naviSideMenuBtnTapped(_ sender: Any)
    {
        if isSeeFewer
        {
            isSeeFewer = false
        }
        self.navigationController!.popViewController(animated: true)
    }*/
}
/*
extension Date {
	/// Returns the amount of years from another date
	func years(from date: Date) -> Int {
		return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
	}
	/// Returns the amount of months from another date
	func months(from date: Date) -> Int {
		return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
	}
	/// Returns the amount of weeks from another date
	func weeks(from date: Date) -> Int {
		return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
	}
	/// Returns the amount of days from another date
	func days(from date: Date) -> Int {
		return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
	}
	/// Returns the amount of hours from another date
	func hours(from date: Date) -> Int {
		return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
	}
	/// Returns the amount of minutes from another date
	func minutes(from date: Date) -> Int {
		return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
	}
	/// Returns the amount of seconds from another date
	func seconds(from date: Date) -> Int {
		return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
	}
	/// Returns the a custom time interval description from another date
	func offset(from date: Date) -> String {
		if years(from: date)   > 0 { return "\(years(from: date))y"   }
		if months(from: date)  > 0 { return "\(months(from: date))M"  }
		if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
		if days(from: date)    > 0 { return "\(days(from: date))d"    }
		if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
		if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
		if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
		return ""
	}
}
*/
