//
//  SessionPDFComposer.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 23/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class SessionPDFComposer: NSObject {

    let pathToInvoiceHTMLTemplate = Bundle.main.path(forResource: "invoice", ofType: "html")
    
    let pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item", ofType: "html")
    
    let pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "last_item", ofType: "html")
    
    let pathToAreaHTMLTemplate = Bundle.main.path(forResource: "area", ofType: "html")
    
    let senderInfo = "Gabriel Theodoropoulos<br>123 Somewhere Str.<br>10000 - MyCity<br>MyCountry"
    
    let dueDate = ""
    
    let paymentMethod = "Wire Transfer"
    
    let logoImageURL = "http://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png"
    
    var invoiceNumber: String!
    
    var pdfFilename: String!
    
    
    override init() {
        super.init()
    }
    
    
    func renderInvoice(scales: [GeriatricScale]) -> String! {
        
        // Store the invoice number for future use.
        self.invoiceNumber = "1"
        
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
            
            // Replace all the placeholders with real values except for the items.
            // The logo image.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logoImageURL)
            
            // Invoice number.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_NUMBER#", with: invoiceNumber)
            
            // Invoice date.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_DATE#", with: invoiceDate)
            
            // Due date (we leave it blank by default).
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DUE_DATE#", with: dueDate)
            
            // Sender info.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#SENDER_INFO#", with: senderInfo)
            
            // Recipient info.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#RECIPIENT_INFO#", with: recipientInfo.replacingOccurrences(of: "\n", with: "<br>"))
            
            // Payment method.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PAYMENT_METHOD#", with: paymentMethod)
            
            // Total amount.
//            HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL_AMOUNT#", with: totalAmount)
            
            // The invoice items will be added by using a loop.
            var allItems = ""
            
            // For all the items except for the last one we'll use the "single_item.html" template.
            // For the last one we'll use the "last_item.html" template.
            
            // TODO group scales by area
            for areaIndex in 0..<Constants.cgaAreas.count{
            
                let area = Constants.cgaAreas[areaIndex]
                // get scales for that area
                let scalesForArea = Constants.getScalesForAreaFromSession(area: area,scales: Constants.cgaPublicScales!)
                
                var areaItems = ""
                
                if scalesForArea.count != 0{
                    // this area contains one or more scales
                    var areaHTMLContent: String!
                    
                    // get area template
                    areaHTMLContent = try String(contentsOfFile: pathToAreaHTMLTemplate!)
                    // set area name
                    areaHTMLContent = areaHTMLContent.replacingOccurrences(of: "#AREA#", with: area)
                    
                    allItems += areaHTMLContent
                    
                    for i in 0..<scalesForArea.count {
                        let scale = scalesForArea[i]
                        var itemHTMLContent: String!
                        
                        // Determine the proper template file.
                        if i != scales.count - 1 {
                            itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
                        }
                        else {
                            itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!)
                        }
                        
                        // Replace the description and price placeholders with the actual values.
                        itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_DESC#", with: scalesForArea[i].scaleName!)
                    
                        itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#QUALITATIVE#", with: ScaleHelper.getQualitativeResult(scale: scale ))
                        itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#QUANTITATIVE#", with: ScaleHelper.getQuantitativeResult(scale: scale))
                        
                            itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#NOTES#", with: scale.notes!)
                        
                        
                        
                        // Add the item's HTML code to the general items string.
                        allItems += itemHTMLContent
                    }
                }
            }
            
            
            
            
            
            // Set the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
            
            // The HTML code is ready.
            return HTMLContent
            
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }
    
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Invoice\(invoiceNumber).pdf"
        pdfData?.write(toFile: pdfFilename, atomically: true)
        
        print(pdfFilename)
    }
    
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        
        UIGraphicsBeginPDFPage()
        
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        
        UIGraphicsEndPDFContext()
        
        return data
    }
    
}
