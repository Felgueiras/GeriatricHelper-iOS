//
//  ReviewSessionTableViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 20/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit
import SwiftMessages
import Instructions
import MessageUI

class ReviewSessionTableViewController: UIViewController {
    
    let showPDF:String = "ShowPDFSegue"
    let coachMarksController = CoachMarksController()

    @IBOutlet weak var closeReview: UIBarButtonItem!
    
    @IBOutlet weak var createPDFButton: UIBarButtonItem!
    var session: Session?
    
    var scales: [GeriatricScale]? = []
    
    // MARK: segues identifiers
    let ViewScaleQuestionsSegue = "ViewScaleQuestions"
    let ViewScaleYesNoSegue = "YesNoQuestion"
    let ViewScaleSingleQuestionChoicesSegue = "CGAViewSingleQuestionChoices"
    
    var sessionPDFComposer: SessionPDFComposer!
    
     var HTMLContent: String!
    
    // MARK: actions and outlets
    @IBAction func createPdfButtonClicked(_ sender: Any) {
     // create HTML -> PDF
        sessionPDFComposer = SessionPDFComposer()
        
        createInvoiceAsHTML()
        
        sessionPDFComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        
        // display options to user (view PDF, send in email)
        showOptionsAlert()
    }
    
    // MARK: Custom Methods
    /**
     Generate HTML content and present it in the Web view
     **/
    func createInvoiceAsHTML() {
        if let invoiceHTML = sessionPDFComposer.renderInvoice(scales: Constants.cgaPublicScales!) {
            
            HTMLContent = invoiceHTML
        }
    }
    
    /**
     Prompt user about what option to take regarding
     PDF (view, send by email, cancel)
     **/
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "PDF da sessão", message: "PDF da sessão criado, o que deseja fazer?", preferredStyle: UIAlertControllerStyle.alert)
        
        let actionPreview = UIAlertAction(title: "Ver PDF", style: UIAlertActionStyle.default) { (action) in
            self.performSegue(withIdentifier: self.showPDF, sender: self)

//            if let filename = self.sessionPDFComposer.pdfFilename, let url = URL(string: filename) {
//                let request = URLRequest(url: url)
////                self.webPreview.loadRequest(request)
//                self.performSegue(withIdentifier: self.showPDF, sender: self)
//            }
        }
        
        let actionEmail = UIAlertAction(title: "Enviar por email", style: UIAlertActionStyle.default) { (action) in
            DispatchQueue.main.async {
                self.sendEmail()
            }
        }
        
        let actionNothing = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default) { (action) in
            
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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControlSelectionChanged(_ sender: Any) {
        // reload the data
        self.table.reloadData()
    }
    
    
    @IBOutlet weak var table: UITableView!
    
    
    @IBAction func finishReviewButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "FinishReviewingPublicSession", sender: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get the scales that were completed
        var completedScales: [GeriatricScale] = []
        for scale in scales!{
            if scale.completed == true{
                completedScales.append(scale)
            }
        }
        
        self.scales = completedScales
        
        // set delegate for table
        self.table.delegate = self
        self.table.dataSource = self
        
        SwiftMessagesHelper.showMessage(type: Theme.success, text: StringHelper.sessionFinished)
        
        // deactivate segmented control areas with no scales
        for index in 0..<segmentedControl.numberOfSegments{
        
            let scalesForArea = Constants.getScalesForAreaFromSession(
                area: Constants.cgaAreas[index],
                scales: scales!)
            
            if scalesForArea.count == 0{
                segmentedControl.setEnabled(false, forSegmentAt: index)
            }
            else
            {
                // select this segment
                segmentedControl.selectedSegmentIndex = index
            
            }
        }
        
        
        // handle Instructions
        self.coachMarksController.overlay.allowTap = true
        
        self.coachMarksController.dataSource = self
        
        
        // change text to icons (if iPhone)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
        // It's an iPhone
             print("phone")
             // functional
            segmentedControl.setImage(#imageLiteral(resourceName: "ic_functional"), forSegmentAt: 0)
             // affective
            segmentedControl.setImage(#imageLiteral(resourceName: "cga_afective"), forSegmentAt: 1)
             // march
            segmentedControl.setImage(#imageLiteral(resourceName: "cga_march"), forSegmentAt: 2)
             // cognitive
            segmentedControl.setImage(#imageLiteral(resourceName: "ic_mental"), forSegmentAt: 3)
             // nutritive
            segmentedControl.setImage(#imageLiteral(resourceName: "ic_nutritional"), forSegmentAt: 4)
        case .pad:
            // It's an iPad
             print("pad")
        default:
            break
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.table.reloadData()
        
        // check user defaults
        if UserDefaults.standard.bool(forKey: "instructions") {
            startInstructions()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.coachMarksController.stop(immediately: true)
    }
    
    func startInstructions() {
        self.coachMarksController.start(on: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // display PDF
        if segue.identifier == showPDF {
            
            
            let destinationViewController = segue.destination as! PreviewViewController
            destinationViewController.HTMLContent = HTMLContent
            
            return
        }
        
        
        
        let scalesForArea = Constants.getScalesForAreaFromSession(area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],scales: scales!)
        
        
        if segue.identifier == ViewScaleQuestionsSegue {
            
            let scale = scalesForArea[(table.indexPathForSelectedRow?.row)!]

            let destinationViewController = segue.destination as! ScaleQuestions
            destinationViewController.scale = scale
            destinationViewController.session = session
            
        }
        else if segue.identifier == ViewScaleSingleQuestionChoicesSegue {
            let scale = scalesForArea[(table.indexPathForSelectedRow?.row)!]

            let destinationViewController = segue.destination as! CGAScaleSingleChoice
            destinationViewController.scale = scale
            destinationViewController.session = session
            
        }
        else if segue.identifier == ViewScaleYesNoSegue {
            let scale = scalesForArea[(table.indexPathForSelectedRow?.row)!]

            let destinationViewController = segue.destination as! CGAPublicYesNo
            destinationViewController.scale = scale
            destinationViewController.session = session

        }
        
        
    }

}

// display Instructions
extension ReviewSessionTableViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    
    // whre to display the coach mark
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        var coachMarkView: UIView?
        
        
        switch index
        {
        case 0:
            // Review
            return coachMarksController.helper.makeCoachMark(for: self.navigationController?.navigationBar) { (frame: CGRect) -> UIBezierPath in
                // This will make a cutoutPath matching the shape of
                // the component (no padding, no rounded corners).
                return UIBezierPath(rect: frame)
            }
        case 1:
            // PDF
            coachMarkView = createPDFButton.customView
        case 2:
            // Close
            coachMarkView = closeReview.customView
        default:
            break
        }
     
        
        
        return coachMarksController.helper.makeCoachMark(for: coachMarkView)
    }
    
    // number of coach marks
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        
       
            return 3
   
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        
        switch index
        {
        case 0:
            // Rever sessão
            coachViews.bodyView.hintLabel.text = "Neste ecrã tem acesso ao resumo da sessão. Pode consultar os resultados de cada escala e, se pretender, gerar um documento PDF."
            coachViews.bodyView.nextLabel.text = "Ok!"
        case 1:
            // PDF
            coachViews.bodyView.hintLabel.text = "Se quiser gerar um PDF com o resumo da sessão, pode clicar aqui."
            coachViews.bodyView.nextLabel.text = "Ok!"
        case 2:
            // Fechar
            coachViews.bodyView.hintLabel.text = "Clique neste botão para sair do resumo."
            coachViews.bodyView.nextLabel.text = "Ok!"
        default:
            break
        }
        
        
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
}

extension ReviewSessionTableViewController: UITableViewDataSource, UITableViewDelegate  {
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentedControl.selectedSegmentIndex == -1{
        return 0
        }
        // get the completed scales for the current area
        let scalesForArea = Constants.getScalesForAreaFromSession(
            area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],
                                              scales: scales!)
        
        return scalesForArea.count
    }
    
    // get cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ScaleTableViewCell", owner: self, options: nil)?.first as! ScaleTableViewCell
        
        // get scale
        let scalesForArea = Constants.getScalesForAreaFromSession(area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],scales: scales!)
        let scale = scalesForArea[indexPath.row]
        
        
        return ScaleTableViewCell.createCell(cell: cell, scale: scale, viewController: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // return the height of the cell
        return 175
    }
    
    
    // select a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get cell and selected scale
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        
        // get the completed scales for the current area
        let scalesForArea = Constants.getScalesForAreaFromSession(area: Constants.cgaAreas[segmentedControl.selectedSegmentIndex],scales: scales!)
        let scale = scalesForArea[indexPath.row]
        
        if scale.singleQuestion!{
            // single question scale - display the choices
            performSegue(withIdentifier: ViewScaleSingleQuestionChoicesSegue, sender: self)
            
        }
        else{
            // multiple choice
            
            if scale.questions?.first?.yesOrNo == true {
                // yes/no
                // "normal" multiple choice
                performSegue(withIdentifier: ViewScaleYesNoSegue, sender: self)
            }
            else
            {
                // "normal" multiple choice
                performSegue(withIdentifier: ViewScaleQuestionsSegue, sender: self)
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
