//
//  Sapcai.swift
//  SAP Conversational AI Official iOS SDK
//
//  Created by Pierre-Edouard LIEB on 24/03/2016.
//

import Foundation
import Alamofire
import ObjectMapper
/**
SapcaiClient class handling request to the API
 */
public class SapcaiClient
{
    static fileprivate let base_url : String = "https://api.cai.tools.sap/v2/"
    static fileprivate let base_url_voice : String = "ws://api.cai.tools.sap/v2/"
    static fileprivate let textRequest : String = base_url + "request"
    static fileprivate let textConverse : String = base_url + "converse"
    static fileprivate let voiceRequest : String = base_url_voice + "request"
    static fileprivate let voiceConverse : String = base_url_voice + "converse"
    static fileprivate let base_url_dialog : String = "https://api.cai.tools.sap/build/v1/"
    static fileprivate let textDialog : String = base_url_dialog + "dialog"

    fileprivate var token : String
    fileprivate let language : String?
    
    /**
     Init SapcaiClient Class
     
     - parameter token: your bot token
     - parameter language: language of sentenses if needed
     
     - returns: SapcaiClient
     */
    public init (token : String, language : String? = nil)
    {
        self.token = token
        self.language = language
    }
    
    /**
     Make a text converse to SAP Conversational AI API
     
     - parameter request: sentence to send to SAP Conversational AI API
     - parameter lang: lang of the sentence if needed
     - parameter successHandler: closure called when request succeed
     - parameter failureHandler: closure called when request failed
     
     - returns: void
     */
    public func converseText(_ request : String, token : String? = nil, converseToken : String? = nil, lang: String? = nil, successHandler: @escaping (ConverseResponse) -> Void, failureHandle: @escaping (Error) -> Void)
    {
        if let tkn = token
        {
            self.token = tkn
        }
        let headers = ["Authorization" : "Token " + self.token]
        var param = ["text" : request]
        if let ln = lang
        {
            param["language"] = ln
        }
        else if let ln = self.language
        {
            param["language"] = ln
        }
        if let cnvrstnTkn = converseToken
        {
            param["conversation_token"] = cnvrstnTkn
        }
        Alamofire.request(SapcaiClient.textConverse, method: .post, parameters: param, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let sapcaiResponse = (value as! [String : AnyObject])["results"] as! [String : Any]
                let converseResponse = Mapper<ConverseResponse>().map(JSON: sapcaiResponse)!
                converseResponse.requestToken = self.token
                successHandler(converseResponse)
            case .failure(let error):
                failureHandle(error)
            }
        }
    }
    
    /**
     Make a text converse to SAP Conversational AI API
     
     - parameter request: sentence to send to SAP Conversational AI API
     - parameter lang: lang of the sentence if needed
     - parameter successHandler: closure called when request succeed
     - parameter failureHandler: closure called when request failed
     
     - returns: void
     */
    public func converseFile(_ audioFileURL: URL, token : String? = nil, converseToken : String? = nil, lang: String? = nil, successHandler: @escaping (ConverseResponse) -> Void, failureHandle: @escaping (Error) -> Void)
    {
        if let tkn = token
        {
            self.token = tkn
        }
        let headers = ["Authorization" : "Token " + self.token]
        var ln : String = lang!
        let conversationToken : String = converseToken!
        if (self.language != nil)
        {
            ln = self.language!
        }
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(audioFileURL, withName: "voice")
            multipartFormData.append(ln.data(using: String.Encoding.utf8)!, withName: "language")
            multipartFormData.append(conversationToken.data(using: String.Encoding.utf8)!, withName: "conversation_token")
        },
         to: SapcaiClient.voiceConverse,
         method: .post,
         headers: headers,
         encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let sapcaiResponse = (value as! [String : AnyObject])["results"] as! [String : Any]
                        let converseResponse = Mapper<ConverseResponse>().map(JSON: sapcaiResponse)!
                        converseResponse.requestToken = self.token
                        successHandler(converseResponse)
                    case .failure(let error):
                        failureHandle(error)
                    }
                }
            case .failure(let encodingError):
                failureHandle(encodingError)
            }
        })
    }
    
    /**
     Make a text request to SAP Conversational AI API
     
     - parameter request: sentence to send to SAP Conversational AI API
     - parameter lang: lang of the sentence if needed
     - parameter successHandler: closure called when request succeed
     - parameter failureHandler: closure called when request failed
     
     - returns: void
     */
    public func analyseText(_ request : String, token : String? = nil, lang: String? = nil, successHandler: @escaping (Response) -> Void, failureHandle: @escaping (Error) -> Void)
    {
        if let tkn = token
        {
            self.token = tkn
        }
        let headers = ["Authorization" : "Token " + self.token]
        var param = ["text" : request]
        if let ln = lang
        {
            param["language"] = ln
        }
        else if let ln = self.language
        {
            param["language"] = ln
        }
        Alamofire.request(SapcaiClient.textRequest, method: .post, parameters: param, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON {
            response in
            switch response.result {
                case .success(let value):
                    let sapcaiResponse = (value as! [String : AnyObject])["results"] as! [String : Any]
                    successHandler(Mapper<Response>().map(JSON: sapcaiResponse)!)
                case .failure(let error):
                    failureHandle(error)
            }
        }
    }
    
    /**
     Make a voice request to SAP Conversational AI API
     
     - parameter audioFileURL: audio file URL to send to SAP Conversational AIAI
     - parameter lang: lang of the sentence if needed
     - parameter successHandler: closure called when request succeed
     - parameter failureHandler: closure called when request failed
     
     - returns: void
     */
    public func analyseFile(_ audioFileURL: URL, token : String? = nil, lang: String? = nil, successHandler: @escaping (Response) -> Void, failureHandle: @escaping (Error) -> Void) {
        if let tkn = token
        {
            self.token = tkn
        }
        let headers = ["Authorization": "Token " + self.token]
        Alamofire.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(audioFileURL, withName: "voice")
        },
        to: SapcaiClient.voiceRequest,
        method: .post,
        headers: headers,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let sapcaiResponse = (value as! [String : AnyObject])["results"] as! [String : Any]
                        successHandler(Mapper<Response>().map(JSON: sapcaiResponse)!)
                    case .failure(let error):
                        failureHandle(error)
                    }
                }
            case .failure(let encodingError):
                        failureHandle(encodingError)
            }
        })
    }
    
    /**
     Engage in a conversation with a bot through the SAP Conversational AI Dialog endpoint
     
     - parameter message: sentence to send to SAP Conversational AI API (required)
     - parameter conversationId: Unique ID of this conversation (required)
     - parameter lang: lang of the sentence if needed
     - parameter successHandler: closure called when request succeed
     - parameter failureHandler: closure called when request failed
     
     - returns: void
     */
    public func dialogText(_ message : String, token : String? = nil, conversationId : String, lang: String? = nil, successHandler: @escaping (DialogResponse) -> Void, failureHandle: @escaping (Error) -> Void)
    {
        if let tkn = token
        {
            self.token = tkn
        }
        let headers = ["Authorization" : "Token " + self.token]
        var param : Parameters = [:]
        param["message"] = ["type":"text", "content":message]
        if let ln = lang
        {
            param["language"] = ln
        }
        else if let ln = self.language
        {
            param["language"] = ln
        }
        param["conversation_id"] = conversationId
        
        Alamofire.request(SapcaiClient.textDialog, method: .post, parameters: param, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let sapcaiResponse = (value as! [String : AnyObject])["results"] as! [String : Any]
                let converseResponse = Mapper<DialogResponse>().map(JSON: sapcaiResponse)!
                successHandler(converseResponse)
            case .failure(let error):
                failureHandle(error)
            }
        }
    }

}

