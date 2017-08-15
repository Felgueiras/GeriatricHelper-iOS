import UIKit
import MessageUI


class PreviewViewController: UIViewController {

    @IBOutlet weak var webPreview: UIWebView!
    
    var invoiceInfo: [String: AnyObject]!
    
    var sessionPDFComposer: SessionPDFComposer!
    
    var HTMLContent: String!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessionPDFComposer = SessionPDFComposer()
        
        webPreview.loadHTMLString(HTMLContent, baseURL: NSURL(string: sessionPDFComposer.pathToInvoiceHTMLTemplate!)! as URL)
    }

    
}
