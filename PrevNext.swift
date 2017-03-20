//
//  Instruction_Controller.swift
//  Blueapron
//
//  Created by CS-23 on 09/12/16.
//  Copyright © 2016 CS-23. All rights reserved.
//

import UIKit
//MARK: - mainCollectionViewCell
class mainCollectionViewCell : UICollectionViewCell{
    
    //MARK: - Initialize Objects
    @IBOutlet var mainView : UIView!
    @IBOutlet var lbl_instructionTitle  :UILabel!
    @IBOutlet var img_instruction : UIImageView!
    @IBOutlet var txt_instructionDetail : UITextView!
}

//MARK: - Instruction_Controller
class Instruction_Controller: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK: - Initialize Objects
    @IBOutlet var naviagtionView : UIView!
    @IBOutlet var lbl_title : UILabel!
    @IBOutlet var lbl_SliderNo : UILabel!
    @IBOutlet var mainView : UIView!
    @IBOutlet var mainCollectionView : UICollectionView!
    @IBOutlet var pagerView : UIView!
    @IBOutlet var mainPager :UIPageControl!
    @IBOutlet var btnLeft : UIButton!
    @IBOutlet var btnRight : UIButton!
    
    //MARK: - Initialize Variables
    let mainCollectionViewCellIdentifier = "mainCell"
    var lastItemIndex : Int = 0
    var textOfDetail : String = ""
    var instructionDataArr : NSArray = NSArray()
    var subDataDict : NSDictionary = NSDictionary()
    var countData : Int = Int()
    
    //MARK: - Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.countData = self.instructionDataArr.count
        
        mainPager.numberOfPages = countData;
        mainView.layer.cornerRadius = 5;
        mainView.layer.masksToBounds = true;
        lbl_SliderNo.text = NSString(format: "1/%ld",self.countData) as String
        
        self.btnLeft.isEnabled = false
        mainCollectionView.isScrollEnabled = false
    }

    // MARK: - UIButton Click Methods
    @IBAction func btn_backClick(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_RightClick(_ sender: Any)
    {
        if(lastItemIndex < self.countData - 1)
        {
            self.btnLeft.isEnabled = true
            if lastItemIndex < 6 - 1
            {
                lastItemIndex += 1
                let indexPath = IndexPath(item: lastItemIndex, section: 0)
                mainCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            }
            
            if(lastItemIndex == self.countData - 1)
            {
                self.btnRight.isEnabled = false
            }
            mainPager.currentPage = lastItemIndex
            lbl_SliderNo.text = NSString(format: "%ld/%ld",  lastItemIndex + 1,self.countData) as String
        }
        else
        {
            self.btnRight.isEnabled = false
            self.btnLeft.isEnabled = true
        }
    }
    
    @IBAction func btn_LeftClick(_ sender: Any)
    {
        if(lastItemIndex > 0)
        {
            self.btnRight.isEnabled = true
            
            lastItemIndex -= 1
            if lastItemIndex == -1
            {
                lastItemIndex = 0
                let indexPath = IndexPath(item: lastItemIndex, section: 0)
                mainCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            }
            else {
                let indexPath = IndexPath(item: lastItemIndex, section: 0)
                mainCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            }
            
            if(lastItemIndex == 0)
            {
                self.btnLeft.isEnabled = false
            }
            mainPager.currentPage = lastItemIndex
            lbl_SliderNo.text = NSString(format: "%ld/%ld",  lastItemIndex + 1,self.countData) as String
        }
        else
        {
            self.btnRight.isEnabled = true
            self.btnLeft.isEnabled = false
        }
    }

    
    //MARK: - UICollectionView Delegate & DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return countData
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : mainCollectionViewCell = (mainCollectionView.dequeueReusableCell(withReuseIdentifier: mainCollectionViewCellIdentifier, for: indexPath) as! mainCollectionViewCell)
        cell.layer.cornerRadius = 8.0
        cell.lbl_instructionTitle.text = (self.instructionDataArr.object(at: indexPath.row) as AnyObject).value(forKey: "title") as? String
        let imgUrl : String = (self.instructionDataArr.object(at: indexPath.row) as AnyObject).value(forKey: "image") as! String
        cell.img_instruction.sd_setImage(with: NSURL(string: imgUrl) as URL!, placeholderImage: UIImage(named: "italianPasta"))
        
        let htmlText = (self.instructionDataArr.object(at: indexPath.row) as AnyObject).value(forKey: "description") as! String
        
        var attributedText: NSMutableAttributedString = NSMutableAttributedString(string: htmlText)
        
        if let htmlData = htmlText.data(using: String.Encoding.unicode) {
            do {
                attributedText = try NSMutableAttributedString(data: htmlData, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                
            } catch let e as NSError {
                print("Couldn't translate \(htmlText): \(e.localizedDescription) ")
            }
        }
        
        cell.txt_instructionDetail.attributedText = attributedText
        
        cell.txt_instructionDetail.font = UIFont(name: "Signika", size: 13.0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width : self.mainCollectionView.frame.size.width , height : self.view.frame.size.height)
    }
    
    //MARK: - UIScrollView Delegate Methods
    /*func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        print("Animation")
        for cell: UICollectionViewCell in mainCollectionView.visibleCells {
            var indexPath = mainCollectionView.indexPath(for: cell)!
            print("index path in scrollViewDidEndScrollingAnimation",indexPath.row)
            mainPager.currentPage = indexPath.row
            lbl_SliderNo.text = NSString(format: "%ld/%ld",  indexPath.row + 1,self.countData) as String
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        
        for cell: UICollectionViewCell in mainCollectionView.visibleCells
        {
            var indexPath = mainCollectionView.indexPath(for: cell)!
              print("index path in scrollViewDidEndDecelerating",indexPath.row)
            mainPager.currentPage = indexPath.row
            lastItemIndex = indexPath.row
            lbl_SliderNo.text = NSString(format: "%ld/%ld",  indexPath.row + 1,self.countData) as String
        }

    }*/
    
    @IBAction func rightSwipe(gesture : UISwipeGestureRecognizer)
    {
        self.btn_LeftClick(self.btnLeft)
    }
    
    @IBAction func leftSwipe(gesture : UISwipeGestureRecognizer)
    {
        self.btn_RightClick(self.btnRight)
    }
    
    //MARK: - Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
