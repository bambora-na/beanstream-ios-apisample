//
//  Session.swift
//  GoldenEggs
//
//  Created by Sven Resch on 2015-12-30.
//  Copyright © 2015 Beanstream Internet Commerce, Inc. All rights reserved.
//

class Session {
    
    var isAuthorized: Bool = false
    var sessionId: String = ""
    var merchantId: String = ""
    var successCode: String = ""
    var username: String = ""
    var userEmail: String = ""
    var userLanguage: String = ""
    var processingPermission: String = ""
    var passwordExpiry: String = ""
    var brandId: String = ""
    var companyPhone: String = ""
    var companyName: String = ""
    var companyAddress1: String = ""
    var companyAddress2: String = ""
    var companyCity: String = ""
    var companyProvince: String = ""
    var companyCountry: String = ""
    var companyPostal: String = ""
    var currencyType: String = ""
    var currencyDecimals: String = ""
    var cardProcessor: String = ""
    
    init(response: BICCreateSessionResponse) {
        self.isAuthorized = response.isAuthorized
        self.sessionId = response.sessionId ?? ""
        self.merchantId = response.merchantId ?? ""
        self.successCode = response.successCode ?? ""
        self.username = response.username ?? ""
        self.userEmail = response.userEmail ?? ""
        self.userLanguage = response.userLanguage ?? ""
        self.processingPermission = response.processingPermission ?? ""
        self.passwordExpiry = response.passwordExpiry ?? ""
        self.brandId = response.brandId ?? ""
        self.companyPhone = response.companyPhone ?? ""
        self.companyName = response.companyName ?? ""
        self.companyAddress1 = response.companyAddress1 ?? ""
        self.companyAddress2 = response.companyAddress2 ?? ""
        self.companyCity = response.companyCity ?? ""
        self.companyProvince = response.companyProvince ?? ""
        self.companyCountry = response.companyCountry ?? ""
        self.companyPostal = response.companyPostal ?? ""
        self.currencyType = response.currencyType ?? ""
        self.currencyDecimals = response.currencyDecimals ?? ""
        self.cardProcessor = response.cardProcessor ?? ""
    }
    
}
