//
//  AppUtilities.swift
//  AutoNome
//
//  Created by CS-15 on 12/23/16.
//  Copyright © 2016 CS-23. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation


class AppUtilities: NSObject {
    
    var sharedInstance: AppUtilities? = nil
	
	//MARK:- shared instance
    class var sharedInstance :AppUtilities {
        struct Singleton {
            static let instance = AppUtilities()
        }
        
        return Singleton.instance
    }
	
	//MARK:- all validation
	
    /*=======================================================
     Function Name: isValidEmail
     Function Param : - String
     Function Return Type : - bool
     Function purpose :- check for valid Email ID
     ========================================================*/
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
	
	
	
	//MARK:- bottomBoredr
	
    /*=======================================================
     Function Name: bottomBoredr
     Function Param : - AnyObject
     Function Return Type : -
     Function purpose :- give bottom border with white color
     ========================================================*/
	
	func bottomBoredr(textField :AnyObject)
	{
		let bottomLine = CALayer()
		bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
		bottomLine.backgroundColor = UIColor.white.cgColor
		textField.layer.addSublayer(bottomLine)
	}
	
    /*=======================================================
     Function Name: bottomBoredrColor
     Function Param : - AnyObject
     Function Return Type : -
     Function purpose :- give bottom border with color code
     ========================================================*/
    
    func bottomBoredrColor(textField :AnyObject)
    {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x : 0, y : textField.frame.height - 1, width : textField.frame.width, height :1.0)
        bottomLine.backgroundColor = UIColor.red.cgColor
        textField.layer.addSublayer(bottomLine)
    }
    
    func drawRedBorderToTextfield(_ txtField:AnyObject, cornerRadius:CGFloat, borderRadius:CGFloat)
    {
        if #available(iOS 8.0, *) {
            txtField.layer.borderWidth=borderRadius
            txtField.layer.cornerRadius=cornerRadius
            txtField.layer.borderColor=UIColor.red.cgColor
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    func drawClearBorderToTextfield(_ txtField:AnyObject,cornerRadius:CGFloat, borderRadius:CGFloat)
    {
        if #available(iOS 8.0, *) {
            txtField.layer.borderWidth=borderRadius
            txtField.layer.cornerRadius=cornerRadius
            txtField.layer.borderColor=UIColor.clear.cgColor
        }
    }
	
	// to view
	func drawRedBorderToView(_ view:UIView, cornerRadius:CGFloat, borderRadius:CGFloat)
	{
		if #available(iOS 8.0, *) {
			view.layer.borderWidth=borderRadius
			view.layer.cornerRadius=cornerRadius
			view.layer.borderColor=UIColor.red.cgColor
			
		} else {
			// Fallback on earlier versions
		}
	}
	
	
	func drawClearBorderToView(_ view:UIView,cornerRadius:CGFloat, borderRadius:CGFloat)
	{
		if #available(iOS 8.0, *) {
			view.layer.borderWidth=borderRadius
			view.layer.cornerRadius=cornerRadius
			view.layer.borderColor=UIColor.clear.cgColor
		}
	}
    /*=======================================================
     Function Name: setPlaceholder
     Function Param : - UITextField, String
     Function Return Type : -
     Function purpose :- set placeholder of white color
     ========================================================*/
    
    func setPlaceholder (textFiled : UITextField , str : String)
    {
        textFiled.attributedPlaceholder = NSAttributedString(string:str,
                                                             attributes:[NSForegroundColorAttributeName: UIColor.white])
    }
    
    /*=======================================================
     Function Name: setPlaceholderGray
     Function Param : - UITextField,String
     Function Return Type : -
     Function purpose :- set placeholder of gray color
     ========================================================*/
    
    func setPlaceholderGray (textFiled : UITextField , str : String)
    {
        textFiled.attributedPlaceholder = NSAttributedString(string:str,
                                                             attributes:[NSForegroundColorAttributeName: UIColor.gray])
    }


	//MARK:- check is network rechable
    func isNetworkRechable() -> Bool
    {
        let reachability = Reachability.forInternetConnection()
        let status : NetworkStatus = reachability!.currentReachabilityStatus()
        
        if status == NotReachable
        {
			
			
            let alert = UIAlertController(title: "Message", message: "unable to connect to the Internet", preferredStyle: UIAlertControllerStyle.alert)
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            self.hideLoader()
            return false
        }
        else
        {
			return true

        }
    }
    
    /*=======================================================
     Function Name: dataTask
     Function Param : - URL,Strig,String,Block
     Function Return Type : -
     Function purpose :- Global Class For API Calling.
     ========================================================*/
    /*
    func dataTask(request: NSMutableURLRequest, method: String,params:NSString, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        request.httpMethod = method
        request.httpBody = params.data(using: String.Encoding.utf8.rawValue)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, json as AnyObject?)
                } else {
                    completion(false, json as AnyObject?)
                }
            }
            }.resume()
    }
    
    func post(request: NSMutableURLRequest,params:NSString, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "POST", params: params, completion: completion)
        
    }
    func put(request: NSMutableURLRequest,params:NSString, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "PUT", params: params, completion: completion)
        
    }
    func get(request: NSMutableURLRequest,params:NSString, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "GET", params: params, completion: completion)
        
    }
    */
	
	//jinal
	func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
		
		let scale = newWidth / image.size.width
		let newHeight = image.size.height * scale
		UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), true, UIScreen.main.scale)
		image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
    
    
    func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {
        
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), true, UIScreen.main.scale)
//        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
	
	func generateBoundaryString() -> String
	{
		return "Boundary-\(NSUUID().uuidString)"
	}
	
	func createBodyWithParameters(parameters: NSMutableDictionary?,boundary: String) -> NSData {
		let body = NSMutableData()
		if parameters != nil {
            
            if (parameters?["video"] as! String).characters.count > 0 {
                
                let filename = "video1.mp4" //"image\(i).png"
                
//                let outputPath = "\(NSTemporaryDirectory())output1.mov"
//                let uploadUrl = URL(fileURLWithPath: outputPath as String)
//                
//                self.compressVideo(inputURL: URL(string: (parameters?["video"] as! String))!, outputURL: uploadUrl, handler: { (handler) in
//                    
//                    if handler.status == AVAssetExportSessionStatus.completed {
//                        print("completedd")
//                    }
//                })
                
                let data = NSData(contentsOf: URL(string: (parameters?["video"] as! String))!)
                let mimetype = "video/mp4"
                
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                
                body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
                
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(data! as Data)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
            }
            else {
                let filename = "image1.png" //"image\(i).png"
                let data = UIImageJPEGRepresentation(parameters?["image"] as! UIImage,1);
                let mimetype = mimeTypeForPath(path: filename)
                
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                
                body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
                
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(data!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
            }
		}
		
		body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
		
		return body
	}
	
	func mimeTypeForPath(path: String) -> String {
		let pathExtension = path
		var stringMimeType = "application/octet-stream";
		if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue() {
			if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
				stringMimeType = mimetype as NSString as String
			}
		}
        
		return stringMimeType;
	}

    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ session: AVAssetExportSession)-> Void)
    {
        let urlAsset = AVURLAsset(url: inputURL as URL, options: nil)

        let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality)
        exportSession!.outputURL = outputURL as URL
        exportSession!.outputFileType = AVFileTypeMPEG4//AVFileTypeQuickTimeMovie
        exportSession!.shouldOptimizeForNetworkUse = true
        exportSession!.exportAsynchronously { () -> Void in
            handler(exportSession!)
        }
    }

	
	//MARK:- data task image method
    func dataTaskImage(_ request: NSMutableURLRequest, method: String,image: UIImage, videoUrl: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
		
		let boundary = generateBoundaryString()
		
		request.httpMethod = method
		request.addValue("bearer \(UserDefaults.standard.value(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		
        var sizedImage: UIImage = UIImage()
    
        if videoUrl.characters.count == 0 {
            sizedImage = self.resizeImage(image: image, newWidth: UIScreen.main.bounds.size.width)
        }
        
        request.httpBody = createBodyWithParameters(parameters: ["image": sizedImage, "video": videoUrl], boundary: boundary) as Data
		
		let session = URLSession(configuration: URLSessionConfiguration.default)
		session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
			
			print("image error : ", error?.localizedDescription ?? "no error")
			
			if let data = data {
				let json = try? JSONSerialization.jsonObject(with: data, options: [])
				if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
					
					let hdict: NSDictionary = response.allHeaderFields as NSDictionary
					print(hdict)
					
					completion(true, json as AnyObject?)
				} else {
					completion(false, json as AnyObject?)
				}
			}
        }.resume()
	}
	
	// chiba style....
	
    func postJson(request: NSMutableURLRequest,jsonObject: [AnyObject], completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTaskJson(request, method: "POST", jsonObject: jsonObject, completion: completion)
        
    }
    
    func post(request: NSMutableURLRequest,jsonObject: [String: AnyObject], completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request, method: "POST", jsonObject: jsonObject, completion: completion)
		
    }
	
    func put(request: NSMutableURLRequest,jsonObject: [String: AnyObject], completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request, method: "PUT", jsonObject: jsonObject, completion: completion)
		
    }
	
    func get(request: NSMutableURLRequest,jsonObject: [String: AnyObject], completion:@escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request, method: "GET", jsonObject: jsonObject, completion: completion)
        
    }
    
    func dataTaskJson(_ request: NSMutableURLRequest, method: String,jsonObject: [AnyObject], completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("bearer \(UserDefaults.standard.value(forKey: "access_token")!)", forHTTPHeaderField: "Authorization")
		
        if(method == "POST")
        {
            let data : Data!
            let err : NSError! = nil
            do{
                data = try! JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted)
            }
            catch
            {
                print(err)
            }
            request.httpBody = data
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                
                let str1: NSString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                print("response str : ", str1)
                
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    
                    let hdict: NSDictionary = response.allHeaderFields as NSDictionary
                    print(hdict)
                    
                    completion(true, json as AnyObject?)
                } else {
                    completion(false, json as AnyObject?)
                }
            }
            }.resume()
    }
	
	//MARK:- data task method
    func dataTask(_ request: NSMutableURLRequest, method: String,jsonObject: [String: AnyObject], completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		
		// added
		//request.timeoutInterval = 239
		//
		
		if let token : NSString = UserDefaults.standard.value(forKey: "access_token") as? NSString
		{
			request.addValue("bearer \(token)", forHTTPHeaderField: "Authorization")
		}

        if(method == "POST")
        {
            let data : Data!
            let err : NSError! = nil
            do{
                data = try! JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted)
            }
            catch
            {
                print(err)
            }
            request.httpBody = data
        }
        else if(method == "GET")
        {
            
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                
                let str1: NSString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                print("response str : ", str1)
                
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    
                    let hdict: NSDictionary = response.allHeaderFields as NSDictionary
                    print(hdict)
                    
                    completion(true, json as AnyObject?)
                } else {
                    completion(false, json as AnyObject?)
                }
            }
            }.resume()
    }

	//MARK:- data task1 method
    func dataTask1(request: NSMutableURLRequest, method: String,params:NSString, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        request.httpMethod = method
        request.httpBody = params.data(using: String.Encoding.utf8.rawValue)
		
		// added
		/*
		if UserDefaults.standard.object(forKey: "userHeaderDict") != nil
		{
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			if let token : NSString = UserDefaults.standard.value(forKey: "access_token") as? NSString
			{
				request.addValue("bearer \(token)", forHTTPHeaderField: "Authorization")
			}
			
			request.timeoutInterval = 239
			request.addValue("\(UInt(params.length))", forHTTPHeaderField: "Content-length")
		}
		else
		{
			request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
			
			
			request.timeoutInterval = 239
			request.addValue("\(UInt(params.length))", forHTTPHeaderField: "Content-length")
			
		}
		*/
		//
		
		
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
				/*
				/// added
				let str1: NSString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
				print("response str : ", str1)
				///
				*/
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
					
					let hdict: NSDictionary = response.allHeaderFields as NSDictionary
					UserDefaults.standard.set(NSMutableDictionary(dictionary: hdict), forKey: "userHeaderDict")
					
					
					let defaultuDict : NSMutableDictionary = UserDefaults.standard.value(forKey:"userHeaderDict") as! NSMutableDictionary
					let mutableCopy : NSMutableDictionary = defaultuDict.mutableCopy() as! NSMutableDictionary
					let str : String = defaultuDict.value(forKey: "ObjUser") as! String
					var subDict : NSDictionary = NSDictionary()
					let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)!
					
					do {
							let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
							print(json)
							subDict = json as NSDictionary
							
							let dict2: [NSObject : AnyObject] = subDict as [NSObject : AnyObject]
							let k : GlobalClass = GlobalClass.sharedInstance()
							let datas = k.dictionaryByReplacingNulls(withStrings: dict2) as NSDictionary
							
							mutableCopy.setValue(datas, forKey: "ObjUser")
							UserDefaults.standard.removeObject(forKey: "userHeaderDict")
							UserDefaults.standard.set(mutableCopy, forKey: "userHeaderDict")
						}
					catch let error as NSError {
						print("Failed to load: \(error.localizedDescription)")
					}
					
                    UserDefaults.standard.set(hdict.value(forKey: "ID"), forKey: "ID")
                    UserDefaults.standard.set(hdict.value(forKey: "Username"), forKey: "username")
                    UserDefaults.standard.set(hdict.value(forKey: "UserType"), forKey: "UserType")
				
					completion(true, json as AnyObject?)
                } else {
                    completion(false, json as AnyObject?)
                }
            }
		}.resume()
 }
    
    /*
    func dataTask(request: NSMutableURLRequest, method: String,jsonObject: [String: AnyObject], completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        request.httpMethod = method
        
        if(method == "POST")
        {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let data : NSData!
            let err : NSError! = nil
            
            do{
                data = try! JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData!
            }
            catch
            {
                print(err)
            }
            
            request.httpBody = data as Data?
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, json as AnyObject?)
                } else {
                    completion(false, json as AnyObject?)
                }
            }
            }.resume()
        
    }
*/
    
    /*=======================================================
     Function Name: showAlert
     Function Param : - String
     Function Return Type : -
     Function purpose :- Show Alert With specific Message
     ========================================================*/
    
    func showAlert(title : NSString, msg : NSString)
    {
		
        let alert = UIAlertView(title: title as String, message: msg as String, delegate: nil, cancelButtonTitle: "OK")
        DispatchQueue.main.async {
            alert.show()
        }
        //        DispatchQueue.main.async(execute: { () -> Void in
        //
        //            alert.show()
        //            }
        //        })
    }
    
    /*=======================================================
     Function Name: showLoader
     Function Param : -
     Function Return Type : -
     Function purpose :- Show Loader
     ========================================================*/
    
    //MARK:- Loader hide show methods
    func showLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 100
        config.backgroundColor = UIColor.white
        config.spinnerColor = UIColor.black
        config.titleTextColor = UIColor.black
        config.spinnerLineWidth = 1.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.5
        
        SwiftLoader.setConfig(config: config)
        SwiftLoader.show(title: "Loading...", animated: true)
    }
    
    func hideLoader()
    {
        DispatchQueue.main.async {
            SwiftLoader.hide()
        }
        
    }

	func setViewsShadow(view: UIView)
	{
		view.layer.shadowColor = UIColor.lightGray.cgColor
		view.layer.shadowOffset = CGSize(width: 1, height: 1)
		view.layer.shadowOpacity = 0.6
		view.layer.shadowRadius = 1.0
	}
	
    func showLoading(with view1: UIView, withLabel lblString: String) {
        DejalBezelActivityView(for: view1, withLabel: lblString, width: 0)
        //        DejalBezelActivityView(for: view1, withLabel: lblString)
    }
    
    func hideLoading() {
        DejalBezelActivityView.remove(animated: true)
    }
	
	// MARK:- Card verification
	
	enum CardType: String {
		case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay
		
		static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]
		
		var regex : String {
			switch self {
			case .Amex:
				return "^3[47][0-9]{2}$" //"^3[47][0-9]{13}$" //"^3[47][0-9]{13}$"//"^3[47][0-9]{5,}$"
			case .Visa:
				return  "^4[0-9]{1,}([0-9]{3})?$" //"^4[0-9]{15}?" //"^4[0-9]{12}(?:[0-9]{3})?$" // //"^4[0-9]{1}?"
			case .MasterCard:
				return "^5[1-5][0-9]{2}$" //"^5[1-5][0-9]{14}$" //"^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$" //"^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
			case .Diners:
				return "^3(?:0[0-5]|[68][0-9])[0-9]$" //"^3(?:0[0-5]|[68][0-9])[0-9]{11}$" //"^3(?:0[0-5]|[68][0-9])[0-9]{11}$" //"^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
			case .Discover:
				return "^6(?:011|5[0-9]{2})$" //"^6(?:011|5[0-9]{2})[0-9]{12}$" //"^6(?:011|5[0-9]{2})[0-9]{12}$" //"^6(?:011|5[0-9]{2})[0-9]{3,}$"
			case .JCB:
				return "^35[0-9]{2}$" //"^35[0-9]{14}$" //"^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
			case .UnionPay:
				return "^(62|88)[0-9]{5,}$"
			case .Hipercard:
				return "^(606282|3841)[0-9]{5,}$"
			case .Elo:
				return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
			default:
				return ""
			}
		}
	}
	
	
	
	func matchesRegex(regex: String!, text: String!) -> Bool {
		do {
			let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
			let nsString = text as NSString
			let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
			return (match != nil)
		} catch {
			return false
		}
	}
	
	
	
	func luhnCheck(number: String) -> Bool
	{
		var sum = 0
		let digitStrings = number.characters.reversed().map { String($0) }
		
		for tuple in digitStrings.enumerated() {
			guard let digit = Int(tuple.element) else { return false }
			let odd = Int(tuple.element)! % 2 == 1
			
			switch (odd, digit) {
			case (true, 9):
				sum += 9
			case (true, 0...8):
				sum += (digit * 2) % 9
			default:
				sum += digit
			}
		}
		
		return sum % 10 == 0
	}
	
	
	
	func checkCardNumber(input: String) -> (type: CardType, formatted: String, valid: Bool) {
		// Get only numbers from the input string
		let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "")
		
		var type: CardType = .Unknown
		var formatted = ""
		var valid = false
		
		// detect card type
		for card in CardType.allCards
		{
			if (matchesRegex(regex: card.regex, text: numberOnly)) {
				type = card
				break
			}
		}
		
		// check validity
		valid = luhnCheck(number: numberOnly)
		
		// format
		var formatted4 = ""
		for character in numberOnly.characters {
			if formatted4.characters.count == 4 {
				formatted += formatted4 + " "
				formatted4 = ""
			}
			formatted4.append(character)
		}
		
		formatted += formatted4 // the rest
		
		// return the tuple
		return (type, formatted, valid)
	}
	
	

}
//TextField Inset//

class MyTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
