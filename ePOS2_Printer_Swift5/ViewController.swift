

import UIKit

class ViewController: UIViewController, DiscoveryViewDelegate, CustomPickerViewDelegate, Epos2PtrReceiveDelegate, Epos2PrinterSettingDelegate {
    func onGetPrinterSetting(_ code: Int32, type: Int32, value: Int32) {
        print(String(code) + " | " + String(type) + " | " + String(value))
    }

    func onSetPrinterSetting(_ code: Int32) {
        // NoOp
    }

    let PAGE_AREA_HEIGHT: Int = 500
    let PAGE_AREA_WIDTH: Int = 500
    let FONT_A_HEIGHT: Int = 24
    let FONT_A_WIDTH: Int = 12
    let BARCODE_HEIGHT_POS: Int = 70
    let BARCODE_WIDTH_POS: Int = 110
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var buttonDiscovery: UIButton!
    @IBOutlet weak var buttonLang: UIButton!
    @IBOutlet weak var buttonPrinterSeries: UIButton!
    @IBOutlet weak var buttonReceipt: UIButton!
    @IBOutlet weak var buttonCoupon: UIButton!
    @IBOutlet weak var textWarnings: UITextView!
    @IBOutlet weak var textTarget: UITextField!

    var printerList: CustomPickerDataSource?
    var langList: CustomPickerDataSource?
    
    var printerPicker: CustomPickerView?
    var langPicker: CustomPickerView?
    
    var printer: Epos2Printer?
    
    var valuePrinterSeries: Epos2PrinterSeries = EPOS2_TM_M10
    var valuePrinterModel: Epos2ModelLang = EPOS2_MODEL_ANK
    
    var target: String?

    var isExecutingMultipleLabels = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        printerList = CustomPickerDataSource()
        printerList!.addItem(NSLocalizedString("printerseries_m10", comment:""), value: EPOS2_TM_M10)
        printerList!.addItem(NSLocalizedString("printerseries_m30", comment:""), value: EPOS2_TM_M30)
        printerList!.addItem(NSLocalizedString("printerseries_p20", comment:""), value: EPOS2_TM_P20)
        printerList!.addItem(NSLocalizedString("printerseries_p60", comment:""), value: EPOS2_TM_P60)
        printerList!.addItem(NSLocalizedString("printerseries_p60ii", comment:""), value: EPOS2_TM_P60II)
        printerList!.addItem(NSLocalizedString("printerseries_p80", comment:""), value: EPOS2_TM_P80)
        printerList!.addItem(NSLocalizedString("printerseries_t20", comment:""), value: EPOS2_TM_T20)
        printerList!.addItem(NSLocalizedString("printerseries_t60", comment:""), value: EPOS2_TM_T60)
        printerList!.addItem(NSLocalizedString("printerseries_t70", comment:""), value: EPOS2_TM_T70)
        printerList!.addItem(NSLocalizedString("printerseries_t81", comment:""), value: EPOS2_TM_T81)
        printerList!.addItem(NSLocalizedString("printerseries_t82", comment:""), value: EPOS2_TM_T82)
        printerList!.addItem(NSLocalizedString("printerseries_t83", comment:""), value: EPOS2_TM_T83)
        printerList!.addItem(NSLocalizedString("printerseries_t83iii", comment:""), value: EPOS2_TM_T83III)
        printerList!.addItem(NSLocalizedString("printerseries_t88", comment:""), value: EPOS2_TM_T88)
        printerList!.addItem(NSLocalizedString("printerseries_t90", comment:""), value: EPOS2_TM_T90)
        printerList!.addItem(NSLocalizedString("printerseries_t90kp", comment:""), value: EPOS2_TM_T90KP)
        printerList!.addItem(NSLocalizedString("printerseries_t100", comment:""), value: EPOS2_TM_T100)
        printerList!.addItem(NSLocalizedString("printerseries_u220", comment:""), value: EPOS2_TM_U220)
        printerList!.addItem(NSLocalizedString("printerseries_u330", comment:""), value: EPOS2_TM_U330)
        printerList!.addItem(NSLocalizedString("printerseries_l90", comment:""), value: EPOS2_TM_T20)
        printerList!.addItem(NSLocalizedString("printerseries_h6000", comment:""), value: EPOS2_TM_H6000)
        printerList!.addItem(NSLocalizedString("printerseries_m30ii", comment:""), value: EPOS2_TM_M30II)
        printerList!.addItem(NSLocalizedString("printerseries_ts100", comment:""), value: EPOS2_TS_100)
        printerList!.addItem(NSLocalizedString("printerseries_m50", comment:""), value: EPOS2_TM_M50)
        printerList!.addItem(NSLocalizedString("printerseries_t88vii", comment:""), value: EPOS2_TM_T88VII)
        printerList!.addItem(NSLocalizedString("printerseries_l90lfc", comment:""), value: EPOS2_TM_L90LFC)
        printerList!.addItem(NSLocalizedString("printerseries_l100", comment:""), value: EPOS2_TM_L100)
        printerList!.addItem(NSLocalizedString("printerseries_p20ii", comment:""), value: EPOS2_TM_P20II)
        printerList!.addItem(NSLocalizedString("printerseries_p80ii", comment:""), value: EPOS2_TM_P80II)
        printerList!.addItem(NSLocalizedString("printerseries_m30iii", comment:""), value: EPOS2_TM_M30III)

        
        langList = CustomPickerDataSource()
        langList!.addItem(NSLocalizedString("language_ank", comment:""), value: EPOS2_MODEL_ANK)
        langList!.addItem(NSLocalizedString("language_japanese", comment:""), value: EPOS2_MODEL_JAPANESE)
        langList!.addItem(NSLocalizedString("language_chinese", comment:""), value: EPOS2_MODEL_CHINESE)
        langList!.addItem(NSLocalizedString("language_taiwan", comment:""), value: EPOS2_MODEL_TAIWAN)
        langList!.addItem(NSLocalizedString("language_korean", comment:""), value: EPOS2_MODEL_KOREAN)
        langList!.addItem(NSLocalizedString("language_thai", comment:""), value: EPOS2_MODEL_THAI)
        langList!.addItem(NSLocalizedString("language_southasia", comment:""), value: EPOS2_MODEL_SOUTHASIA)
        
        printerPicker = CustomPickerView()
        langPicker = CustomPickerView()
        let window = UIApplication.shared.keyWindow
        if (window != nil) {
            window!.addSubview(printerPicker!)
            window!.addSubview(langPicker!)
        }
        else{
            self.view.addSubview(printerPicker!)
            self.view.addSubview(langPicker!)
        }
        printerPicker!.delegate = self
        langPicker!.delegate = self
        
        printerPicker!.dataSource = printerList
        langPicker!.dataSource = langList
        
        valuePrinterSeries = printerList!.valueItem(19) as! Epos2PrinterSeries
        buttonPrinterSeries.setTitle(printerList!.textItem(19), for:UIControl.State())
        valuePrinterModel = langList!.valueItem(0) as! Epos2ModelLang
        buttonLang.setTitle(langList!.textItem(0), for:UIControl.State())
        
        setDoneToolbar()
        
        let result = Epos2Log.setLogSettings(EPOS2_PERIOD_PERMANENT.rawValue,
                                                     output: EPOS2_OUTPUT_STORAGE.rawValue,
                                                     ipAddress: nil,
                                                     port: 0,
                                                     logSize: 50,
                                                     logLevel: EPOS2_LOGLEVEL_LOW.rawValue)
        if result != EPOS2_SUCCESS.rawValue {
            MessageView.showErrorEpos(result, method: "setLogSettings")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        initializePrinterObject()
        target = textTarget.text
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        finalizePrinterObject()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDoneToolbar() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        doneToolbar.sizeToFit()
        let space = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.flexibleSpace, target:self, action:nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.done, target:self, action:#selector(ViewController.doneKeyboard(_:)))
        
        doneToolbar.setItems([space, doneButton], animated:true)
        textTarget.inputAccessoryView = doneToolbar
    }
    
    @objc func doneKeyboard(_ sender: AnyObject) {
        textTarget.resignFirstResponder()
        target = textTarget.text
    }

    @IBAction func didTouchUpInside(_ sender: AnyObject) {
        textTarget.resignFirstResponder()
        
        switch sender.tag {
        case 1:
            printerPicker!.showPicker()
        case 2:
            langPicker!.showPicker()
        case 3:
            showIndicator(NSLocalizedString("wait", comment:""));
            textWarnings.text = ""
            let queue = OperationQueue()
            queue.addOperation({ [self] in
                if !runOneLabelImageSequence() {
                    hideIndicator();
                }
            })
            break
        case 4:
            showIndicator(NSLocalizedString("wait", comment:""));
            textWarnings.text = ""
            let queue = OperationQueue()
            queue.addOperation({ [self] in
                if !runMultiLabelImageSequence() {
                    hideIndicator();
                }
            })
            break
        default:
            break
        }
    }
    
    func customPickerView(_ pickerView: CustomPickerView, didSelectItem text: String, itemValue value: Any) {
        if pickerView == printerPicker {
            self.buttonPrinterSeries.setTitle(text, for:UIControl.State())
            self.valuePrinterSeries = value as! Epos2PrinterSeries
        }
        if pickerView == langPicker {
            self.buttonLang.setTitle(text, for:UIControl.State())
            self.valuePrinterModel = value as! Epos2ModelLang
        }

        finalizePrinterObject()
        initializePrinterObject()
    }
    
    @IBAction func getSettings(_ sender: Any) {
        var result: Int32 = EPOS2_SUCCESS.rawValue

        if printer == nil {
            return
        }

        //Note: This API must be used from background thread only
        result = printer!.connect(target, timeout:Int(EPOS2_PARAM_DEFAULT))
        if result != EPOS2_SUCCESS.rawValue {
            MessageView.showErrorEpos(result, method:"connect")
            return
        } else {
            printer?.getSetting(Int(EPOS2_PARAM_DEFAULT), type: 0, delegate: self)
        }
    }

    func runOneLabelImageSequence(_ transact: Bool = false, imageIndex: Int = 1) -> Bool {
        var result = EPOS2_SUCCESS.rawValue

//        guard let image = UIImage(named: "1 - 2.25_x1.25_ at 203 dpi 410x210 with num"), let logoData = image.bandw().resizeImageTo(size: CGSize(width: 410.0, height: 210.0)) else {
//            return false
//        }

        guard let logoData = UIImage(named: "\(imageIndex) - 2.25_x1.25_ at 203 dpi 410x210 with num") else {
            return false
        }

        if transact { let _ = printer!.beginTransaction() }

        result = printer!.addCommand(Data(esc_pos: .feedToPrintStart))
        if result != EPOS2_SUCCESS.rawValue {
            printer!.clearCommandBuffer()
            MessageView.showErrorEpos(result, method:"feedToPrintStart")
            return false
        }

        result = printer!.add(logoData,
                              x: 0,
                              y: 0,
                              width: Int(logoData.size.width),
                              height: Int(logoData.size.height),
                              color: EPOS2_COLOR_1.rawValue,
                              mode: EPOS2_MODE_MONO.rawValue,
                              halftone: EPOS2_HALFTONE_DITHER.rawValue,
                              brightness: Double(EPOS2_PARAM_DEFAULT),
                              compress: EPOS2_COMPRESS_AUTO.rawValue)
        if result != EPOS2_SUCCESS.rawValue {
            printer!.clearCommandBuffer()
            MessageView.showErrorEpos(result, method:"addImage")
            return false
        }

        result = printer!.addCommand(Data(esc_pos: .feedToPeeler))
        if result != EPOS2_SUCCESS.rawValue {
            printer!.clearCommandBuffer()
            MessageView.showErrorEpos(result, method:"feedToPeeler")
            return false
        }

        result = printer!.addCommand(Data(esc_pos: .feedToCutter))
        if result != EPOS2_SUCCESS.rawValue {
            printer!.clearCommandBuffer()
            MessageView.showErrorEpos(result, method:"feedToCutter")
            return false
        }

//        if !isExecutingMultipleLabels {
//            result = printer!.addCommand(Data(esc_pos: .partialCut))
//            if result != EPOS2_SUCCESS.rawValue {
//                printer!.clearCommandBuffer()
//                MessageView.showErrorEpos(result, method:"partialCut")
//                return false
//            }
//        }

//        result = printer!.addCut(EPOS2_CUT_FEED.rawValue)
//        if result != EPOS2_SUCCESS.rawValue {
//            printer!.clearCommandBuffer()
//            MessageView.showErrorEpos(result, method:"addCut")
//            return false
//        }

        if transact { let _ = printer!.endTransaction() }

        // This will cause a `sendData` to be done.
        if !printData() {
            return false
        }

        return true
    }

    func runMultiLabelImageSequence(_ transact: Bool = false) -> Bool {
        var result = EPOS2_SUCCESS.rawValue

        isExecutingMultipleLabels = true

        for imageIndex in 1...4 {
            isExecutingMultipleLabels = imageIndex != 4
            if !runOneLabelImageSequence(transact, imageIndex: imageIndex) {
                isExecutingMultipleLabels = false
                return false
            }

            sleep(2)
        }

        return true
    }

    func printData() -> Bool {
        if printer == nil {
            return false
        }
        
        if !connectPrinter() {
            printer!.clearCommandBuffer()
            return false
        }

        var result = printer!.sendData(Int(EPOS2_PARAM_DEFAULT))
        if result != EPOS2_SUCCESS.rawValue {
            printer!.clearCommandBuffer()
            MessageView.showErrorEpos(result, method:"sendData")
            printer!.disconnect()
            return false
        }

        return true
    }

    @discardableResult
    func initializePrinterObject() -> Bool {
        printer = Epos2Printer(printerSeries: valuePrinterSeries.rawValue, lang: valuePrinterModel.rawValue)
        
        if printer == nil {
            return false
        }
        printer!.setReceiveEventDelegate(self)

        let path = try? FileManager.default.url(for: .documentDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: true)
        print(path ?? "uh oh")

        return true
    }
    
    func finalizePrinterObject() {
        if printer == nil {
            return
        }

        printer!.setReceiveEventDelegate(nil)
        printer = nil
    }
    
    func connectPrinter() -> Bool {
        var result: Int32 = EPOS2_SUCCESS.rawValue
        
        if printer == nil {
            return false
        }

        if printer?.getStatus().connection == 0 {
            //Note: This API must be used from background thread only
            result = printer!.connect(target, timeout:Int(EPOS2_PARAM_DEFAULT))
            if result != EPOS2_SUCCESS.rawValue {
                MessageView.showErrorEpos(result, method:"connect")
                return false
            }
        }
        
        return true
    }
    
    func disconnectPrinter() {
        var result: Int32 = EPOS2_SUCCESS.rawValue
        
        if printer == nil {
            return
        }
        
        //Note: This API must be used from background thread only
        result = printer!.disconnect()
        if result != EPOS2_SUCCESS.rawValue {
            DispatchQueue.main.async(execute: {
                MessageView.showErrorEpos(result, method:"disconnect")
            })
        }

        printer!.clearCommandBuffer()
    }
    
    func onPtrReceive(_ printerObj: Epos2Printer!, code: Int32, status: Epos2PrinterStatusInfo!, printJobId: String!) {
        
        let queue = OperationQueue()
        queue.addOperation({ [self] in
            self.disconnectPrinter()
            if !self.isExecutingMultipleLabels || code != EPOS2_SUCCESS.rawValue {
                self.hideIndicator();
                MessageView.showResult(code, errMessage: makeErrorMessage(status))
                dispPrinterWarnings(status)
            }
        })
    }
    
    func dispPrinterWarnings(_ status: Epos2PrinterStatusInfo?) {
        if status == nil {
            return
        }
        
        OperationQueue.main.addOperation({ [self] in
            textWarnings.text = ""
        })
        
        if status!.paper == EPOS2_PAPER_NEAR_END.rawValue {
            textWarnings.text = NSLocalizedString("warn_receipt_near_end", comment:"")
        }
        
        if status!.batteryLevel == EPOS2_BATTERY_LEVEL_1.rawValue {
            textWarnings.text = NSLocalizedString("warn_battery_near_end", comment:"")
        }
    }

    func makeErrorMessage(_ status: Epos2PrinterStatusInfo?) -> String {
        let errMsg = NSMutableString()
        if status == nil {
            return ""
        }
    
        if status!.online == EPOS2_FALSE {
            errMsg.append(NSLocalizedString("err_offline", comment:""))
        }
        if status!.connection == EPOS2_FALSE {
            errMsg.append(NSLocalizedString("err_no_response", comment:""))
        }
        if status!.coverOpen == EPOS2_TRUE {
            errMsg.append(NSLocalizedString("err_cover_open", comment:""))
        }
        if status!.paper == EPOS2_PAPER_EMPTY.rawValue {
            errMsg.append(NSLocalizedString("err_receipt_end", comment:""))
        }
        if status!.paperFeed == EPOS2_TRUE || status!.panelSwitch == EPOS2_SWITCH_ON.rawValue {
            errMsg.append(NSLocalizedString("err_paper_feed", comment:""))
        }
        if status!.errorStatus == EPOS2_MECHANICAL_ERR.rawValue || status!.errorStatus == EPOS2_AUTOCUTTER_ERR.rawValue {
            errMsg.append(NSLocalizedString("err_autocutter", comment:""))
            errMsg.append(NSLocalizedString("err_need_recover", comment:""))
        }
        if status!.errorStatus == EPOS2_UNRECOVER_ERR.rawValue {
            errMsg.append(NSLocalizedString("err_unrecover", comment:""))
        }
    
        if status!.errorStatus == EPOS2_AUTORECOVER_ERR.rawValue {
            if status!.autoRecoverError == EPOS2_HEAD_OVERHEAT.rawValue {
                errMsg.append(NSLocalizedString("err_overheat", comment:""))
                errMsg.append(NSLocalizedString("err_head", comment:""))
            }
            if status!.autoRecoverError == EPOS2_MOTOR_OVERHEAT.rawValue {
                errMsg.append(NSLocalizedString("err_overheat", comment:""))
                errMsg.append(NSLocalizedString("err_motor", comment:""))
            }
            if status!.autoRecoverError == EPOS2_BATTERY_OVERHEAT.rawValue {
                errMsg.append(NSLocalizedString("err_overheat", comment:""))
                errMsg.append(NSLocalizedString("err_battery", comment:""))
            }
            if status!.autoRecoverError == EPOS2_WRONG_PAPER.rawValue {
                errMsg.append(NSLocalizedString("err_wrong_paper", comment:""))
            }
        }
        if status!.batteryLevel == EPOS2_BATTERY_LEVEL_0.rawValue {
            errMsg.append(NSLocalizedString("err_battery_real_end", comment:""))
        }
        if (status!.removalWaiting == EPOS2_REMOVAL_WAIT_PAPER.rawValue) {
            errMsg.append(NSLocalizedString("err_wait_removal", comment:""))
        }
        if (status!.unrecoverError == EPOS2_HIGH_VOLTAGE_ERR.rawValue ||
            status!.unrecoverError == EPOS2_LOW_VOLTAGE_ERR.rawValue) {
            errMsg.append(NSLocalizedString("err_voltage", comment:""));
        }
    
        return errMsg as String
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DiscoveryView" {
            let view: DiscoveryViewController? = segue.destination as? DiscoveryViewController
            view?.delegate = self
        }
    }
    func discoveryView(_ sendor: DiscoveryViewController, onSelectPrinterTarget target: String) {
        textTarget.text = target
    }
}

extension String {

    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.

    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }

        guard data.count > 0 else { return nil }

        return data
    }

}


extension Data {

    init(esc_pos cmd: ESC_POSCommand...) {
        self.init(cmd.reduce([], { (r, cmd) -> [UInt8] in
            return r + cmd.rawValue
        }))
    }
}

public struct ESC_POSCommand: RawRepresentable {

    public typealias RawValue = [UInt8]

    public let rawValue: [UInt8]

    public init(rawValue: [UInt8]) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: [UInt8]) {
        self.rawValue = rawValue
    }
}

//Control Commands
extension ESC_POSCommand {
    static var feedToPrintStart: Self {
        ESC_POSCommand([28, 40, 76, 2, 0, 67, 50])
    }

    static var beginUserSettingsMode: Self {
        ESC_POSCommand([29, 40, 69, 3, 0, 1, 73, 78])
    }

    static var setPaperWidth: Self {
        ESC_POSCommand([29, 40, 69, 4, 0, 5, 117, 60, 0])
    }

    static var setPaperLayout: Self {
        ESC_POSCommand([29, 40, 69, 28, 0, 49, 64, 59, UInt8(350 % 256), 59, 40, 59, 70, 59, 20, 59, 250, 59, 50, 59, UInt8(500 % 256), 59])
    }

    static var endUserSettingsMode: Self {
        ESC_POSCommand([29, 40, 69, 3, 0, 1, 79, 85, 84])
    }

    static var feedToPeeler: Self {
        ESC_POSCommand([28, 40, 76, 2, 0, 65, 48])
    }

    static var feedToCutter: Self {
        ESC_POSCommand([28, 40, 76, 2, 0, 66, 48])
    }

    static var partialCut: Self {
        ESC_POSCommand([29, 86, 0])
    }
}

extension UIImage {
    func bandw() -> UIImage {
        guard let currentCGImage = self.cgImage else { return  UIImage()}
        let currentCIImage = CIImage(cgImage: currentCGImage)
        
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")
        
        // set a gray value for the tint color
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        
        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return  UIImage() }
        
        let context = CIContext()
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            return processedImage
        } else {
            return UIImage()
        }
    }
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}


