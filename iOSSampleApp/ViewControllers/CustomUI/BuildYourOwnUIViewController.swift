import Foundation
import UIKit
import Usercentrics

final class BuildYourOwnUIViewController: UIViewController {

    @IBOutlet weak var currentLegalFrameworkLabel: UILabel!

    private lazy var activeVariant = { UsercentricsCore.shared.getCMPData().activeVariant }()
    private lazy var isTCF = { activeVariant == UsercentricsVariant.tcf }()
    private lazy var isCCPA = { activeVariant == UsercentricsVariant.ccpa }()

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
        print("Description: \(settings.bannerMessage ?? "")")

        let services = data.services
        let categories = data.categories

        print("data.settings", settings)
        print("data.services", services)
        print("data.categories", categories)

        print("Accept All button: \(settings.labels.btnAcceptAll)")
        print("Deny button: \(settings.labels.btnDeny)")
        print("Save button: \(settings.labels.btnSave)")
    }

    private func acceptAllForGDPR() {
        UsercentricsCore.shared.acceptAllServices(consentType: .explicit_)

        applyConsent()
    }

    private func denyAllForGDPR() {
        UsercentricsCore.shared.denyAllServices(consentType: .explicit_)

        applyConsent()
    }

    private func updateServicesForGDPR() {
        let decisions: [UserDecision] = []
        UsercentricsCore.shared.updateServices(decisions: decisions, consentType: .explicit_)

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

        let tcfData = UsercentricsCore.shared.getTCFData()
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

        print("TCString", UsercentricsCore.shared.getTCString())
    }

    private func acceptAllForTCF() {
        UsercentricsCore.shared.acceptAllForTCF(fromLayer: .firstLayer)

        applyConsent()
    }

    private func denyAllForTCF() {
        UsercentricsCore.shared.denyAllForTCF(fromLayer: .firstLayer)

        applyConsent()
    }

    private func updateServicesForTCF() {
        let decisions: [UserDecision] = []
        let tcfDecisions = TCFUserDecisions(purposes: [], specialFeatures: [], vendors: [])

        UsercentricsCore.shared.updateChoicesForTCF(decisions: tcfDecisions, fromLayer: .firstLayer)

        applyConsent()
    }

}

// MARK: - UI Methods
extension BuildYourOwnUIViewController {

    @IBAction func didTapPrintUiElements(_ sender: Any) {
        printUiElements()
    }

    private func printUiElements() {
        if (isTCF) {
            printTCFMethods()
            return
        }

        if (isCCPA) {
            printCCPAMethods()
            return
        }

        printGDPRMethods()
    }

    @IBAction func didTapAcceptAll(_ sender: Any) {
        if (isTCF) {
            acceptAllForTCF()
            return
        }

        if (isCCPA) {
            acceptAllForCCPA()
            return
        }

        acceptAllForGDPR()
    }

    @IBAction func didTapDenyAll(_ sender: Any) {
        if (isTCF) {
            denyAllForTCF()
            return
        }

        if (isCCPA) {
            denyAllForCCPA()
            return
        }

        denyAllForGDPR()
    }

    @IBAction func didTapSaveServices(_ sender: Any) {
        if (isTCF) {
            updateServicesForTCF()
            return
        }

        if (isCCPA) {
            print("NO ACTION FOR CCPA")
            return
        }

        updateServicesForGDPR()
    }

    @IBAction func didTapChangeLanguage(_ sender: Any) {
        changeLanguage()
    }

    private func setupUI() {
        title = "Custom UI"
    }
    
    private func showCurrentLegalFramework() {
        var legalFramework: String
        if (isTCF) {
          legalFramework = "TCF 2.0"
        } else if (isCCPA) {
            legalFramework = "CCPA"
        } else {
            legalFramework = "GDPR"
        }

        currentLegalFrameworkLabel.text = legalFramework
    }
}
