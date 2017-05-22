//
//  PreviewViewController.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 14/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import MessageUI


class PreviewViewController: UIViewController {

    @IBOutlet weak var webPreview: UIWebView!
    
    var invoiceInfo: [String: AnyObject]!
    
    var sessionPDFComposer: SessionPDFComposer!
    
    var HTMLContent: String!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createInvoiceAsHTML()
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: IBAction Methods
    
    
    @IBAction func exportToPDF(_ sender: AnyObject) {
        sessionPDFComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        showOptionsAlert()
    }
    
    
    // MARK: Custom Methods
    func createInvoiceAsHTML() {
        sessionPDFComposer = SessionPDFComposer()
        if let invoiceHTML = sessionPDFComposer.renderInvoice(scales: Constants.cgaPublicScales!) {
            
            webPreview.loadHTMLString(invoiceHTML, baseURL: NSURL(string: sessionPDFComposer.pathToInvoiceHTMLTemplate!)! as URL)
            HTMLContent = invoiceHTML
        }
    }
    
    
    
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "Yeah!", message: "Your invoice has been successfully printed to a PDF file.\n\nWhat do you want to do now?", preferredStyle: UIAlertControllerStyle.alert)
        
        let actionPreview = UIAlertAction(title: "Preview it", style: UIAlertActionStyle.default) { (action) in
            if let filename = self.sessionPDFComposer.pdfFilename, let url = URL(string: filename) {
                let request = URLRequest(url: url)
                self.webPreview.loadRequest(request)
            }
        }
        
        let actionEmail = UIAlertAction(title: "Send by Email", style: UIAlertActionStyle.default) { (action) in
            DispatchQueue.main.async {
                self.sendEmail()
            }
        }
        
        let actionNothing = UIAlertAction(title: "Nothing", style: UIAlertActionStyle.default) { (action) in
            
        }
        
        alertController.addAction(actionPreview)
        alertController.addAction(actionEmail)
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.setSubject("Invoice")
            mailComposeViewController.addAttachmentData(NSData(contentsOfFile: sessionPDFComposer.pdfFilename)! as Data, mimeType: "application/pdf", fileName: "Invoice")
            present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
}
