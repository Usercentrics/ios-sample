import Foundation
import UIKit
import Usercentrics

final class BuildYourOwnUIViewController: UIViewController {

    @IBOutlet weak var currentLegalFrameworkLabel: UILabel!

    private var activeVariant: UsercentricsVariant { UsercentricsCore.shared.getCMPData().activeVariant }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showCurrentLegalFramework()
        setupUI()
        printGDPRMethods()
    }
}

// MARK: - Common Methods
extension BuildYourOwnUIViewController {

    private func changeLanguage() {
        UsercentricsCore.shared.changeLanguage(language: "de",
                                               onSuccess: {
                                                print("Success")
                                                self.printUiElements()
                                               }, onFailure: {
                                                print("Failure", $0.localizedDescription)
                                               })
    }

    private func applyConsent() {
        UsercentricsCore.shared.getConsents()
        /// https://docs.usercentrics.com/cmp_in_app_sdk/latest/apply_consent/apply-consent/#apply-consent-to-each-service
    }
}

// MARK: - GDPR Methods
extension BuildYourOwnUIViewController {

    private func printGDPRMethods() {
        let data = UsercentricsCore.shared.getCMPData()
        let settings = data.settings

        print("Title: \(settings.labels.firstLayerTitle)")
        print("Description: \(settings.firstLayerDescription.string)")

        let services = data.services
        let categories = data.categories

        print("data.services", services)
        print("data.categories", categories)

        print("Accept All button: \(settings.labels.btnAcceptAll)")
        print("Deny button: \(settings.labels.btnDeny)")
        print("Save button: \(settings.labels.btnSave)")
    }

    private func acceptAllForGDPR() {
        UsercentricsCore.shared.acceptAll(consentType: .explicit_)

        applyConsent()
    }

    private func denyAllForGDPR() {
        UsercentricsCore.shared.denyAll(consentType: .explicit_)

        applyConsent()
    }

    private func updateServicesForGDPR() {
        let decisions: [UserDecision] = []
        UsercentricsCore.shared.saveDecisions(decisions: decisions, consentType: .explicit_)

        applyConsent()
    }
}

// MARK: - CCPA Methods
extension BuildYourOwnUIViewController {

    private func printCCPAMethods() {
        let data = UsercentricsCore.shared.getCMPData()
        let settings = data.settings
        guard let ccpa = settings.ccpa else {
            return
        }

        print("Title: \(ccpa.firstLayerTitle)")
        print("Description: \(ccpa.appFirstLayerDescription ?? "")")

        let services = data.services
        let categories = data.categories

        print("data.services", services)
        print("data.categories", categories)

        print("Do not sell my info: \(ccpa.optOutNoticeLabel)")
        print("Save: \(ccpa.btnSave)")
    }

    private func acceptAllForCCPA() {
        UsercentricsCore.shared.saveOptOutForCCPA(isOptedOut: false, consentType: .explicit_)

        applyConsent()
    }

    private func denyAllForCCPA() {
        UsercentricsCore.shared.saveOptOutForCCPA(isOptedOut: true, consentType: .explicit_)

        applyConsent()
    }
}

// MARK: - TCF Methods
extension BuildYourOwnUIViewController {

    private func printTCFMethods() {
        print("Set your CMP ID")
        UsercentricsCore.shared.setCMPId(id: 0)

        let data = UsercentricsCore.shared.getCMPData()
        guard let tcf2 = data.settings.tcf2 else {
            return
        }

        print("First layer title: \(tcf2.firstLayerTitle)")
        print("First layer description: \(tcf2.firstLayerDescription ?? "")")

        print("Second layer title: \(tcf2.secondLayerTitle)")
        print("Second layer description: \(tcf2.secondLayerDescription ?? "")")

        UsercentricsCore.shared.getTCFData { tcfData in
            print("tcfData", tcfData)
            print("purposes", tcfData.purposes)
            print("specialPurposes", tcfData.specialPurposes)
            print("features", tcfData.features)
            print("specialFeatures", tcfData.specialFeatures)
            print("stacks", tcfData.stacks)
            print("vendors", tcfData.vendors)

            print("Accept All button: \(tcf2.buttonsAcceptAllLabel)")
            print("Deny button: \(tcf2.buttonsDenyAllLabel)")
            print("Save button: \(tcf2.buttonsSaveLabel)")

            print("TCString", tcfData.tcString)
        }
    }

    private func acceptAllForTCF() {
        UsercentricsCore.shared.acceptAllForTCF(fromLayer: .firstLayer, consentType: .explicit_)

        applyConsent()
    }

    private func denyAllForTCF() {
        UsercentricsCore.shared.denyAllForTCF(fromLayer: .firstLayer, consentType: .explicit_)

        applyConsent()
    }

    private func updateServicesForTCF() {
        let decisions: [UserDecision] = []
        let tcfDecisions = TCFUserDecisions(purposes: [], specialFeatures: [], vendors: [])

        UsercentricsCore.shared.saveDecisionsForTCF(tcfDecisions: tcfDecisions, fromLayer: .firstLayer, serviceDecisions: decisions, consentType: .explicit_)
        applyConsent()
    }

}

// MARK: - UI Methods
extension BuildYourOwnUIViewController {

    @IBAction func didTapPrintUiElements(_ sender: Any) {
        printUiElements()
    }

    private func printUiElements() {
        switch activeVariant {
            case .tcf:
                printTCFMethods()
            case .ccpa:
                printCCPAMethods()
            default:
                printGDPRMethods()
        }
    }

    @IBAction func didTapAcceptAll(_ sender: Any) {
        switch activeVariant {
            case .tcf:
                acceptAllForTCF()
            case .ccpa:
                acceptAllForCCPA()
            default:
                acceptAllForGDPR()
        }
    }

    @IBAction func didTapDenyAll(_ sender: Any) {
        switch activeVariant {
            case .tcf:
                denyAllForTCF()
            case .ccpa:
                denyAllForCCPA()
            default:
                denyAllForGDPR()
        }
    }

    @IBAction func didTapSaveServices(_ sender: Any) {
        switch activeVariant {
            case .tcf:
                updateServicesForTCF()
            case .ccpa:
                print("NO ACTION FOR CCPA")
            default:
                updateServicesForGDPR()
        }
    }

    @IBAction func didTapChangeLanguage(_ sender: Any) {
        changeLanguage()
    }

    private func setupUI() {
        title = "Custom UI"
    }
    
    private func showCurrentLegalFramework() {
        let legalFramework: String

        switch activeVariant {
            case .tcf:
                legalFramework = "TCF 2.0"
            case .ccpa:
                legalFramework = "CCPA"
            default:
                legalFramework = "GDPR"
        }

        currentLegalFrameworkLabel.text = legalFramework
    }
}
