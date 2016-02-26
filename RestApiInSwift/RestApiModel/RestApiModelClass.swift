//
//  RestApiModelClass.swift
//  RestApiInSwift
//
//  Created by Aman Sandhu on 26/02/16.
//  Copyright © 2016 Chetu. All rights reserved.
//

import UIKit

protocol RestApiModelClassDelegate
{
    func restApiDelegateWith( var responseDictionary: [String : AnyObject]!,  let apiIdentifier: String)
    
}

class RestApiModelClass: NSObject {

    static let sharedInstance = RestApiModelClass()

    var delegate: RestApiModelClassDelegate?

    func getRequestRestApiWith(let requestDictionary: [NSObject : AnyObject]!, var requestUrl: String, var apiIdentifier: String)
    {
        
        let reqDict: NSDictionary = requestDictionary
        print(reqDict)
        
        /* NSDicionary to NSData */
        let data = NSKeyedArchiver.archivedDataWithRootObject(reqDict)
        
        /* NSData to NSDicionary */
        let unarchivedDictionary: NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSDictionary
        print(unarchivedDictionary)
        
        let urlString: String = "http://52.26.51.95:8000/registerGuest"
        let url: NSURL = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSKeyedArchiver.archivedDataWithRootObject(reqDict)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if data != nil
            {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)  as! String
                print("Body: \(strData)")

                var responseDict = [String: AnyObject]()
                do {
                    
                    try responseDict = (NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject])!
                    //try  print("Response: \(NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject])")
                } catch let error as NSError {
                    print(error)
                }
                
                self.delegate?.restApiDelegateWith(responseDict, apiIdentifier: apiIdentifier)
            }
            else
            {
                let responseDict = [String: AnyObject]()
                self.delegate?.restApiDelegateWith(responseDict, apiIdentifier: apiIdentifier)
            }
        })
        
        task.resume()
    }
}
