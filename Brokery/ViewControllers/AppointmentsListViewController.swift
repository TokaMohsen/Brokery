//
//  AppointmentsListViewController.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class AppointmentsListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var appointmentsTableView: UITableView!
    
    @IBOutlet var numberOfAppointmentsLbl: UILabel!
    @IBOutlet var appointmentDateLbl: UILabel!
    @IBOutlet var appointmentDayLbl: UILabel!
    private lazy var appointmentsListService = GetAppointmentsListService()
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var getappointmentsListTask: URLSessionDataTask!
    var appointmentList = [AppointmentDto]()
    var appointmentCardColor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.addTarget(self, action: Selector("handlePicker:"), for: UIControl.Event.valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = appointmentsTableView.dequeueReusableCell(withIdentifier: "AppointmentCard", for: indexPath) as? AppointmentCard else {
            return UITableViewCell()
        }
        cell.setup(appointmentList[indexPath.row], coloredCard: appointmentCardColor)
        appointmentCardColor = !appointmentCardColor
        return cell
    }
    
    
    private func fetchData(dateTime : String)
    {
        getappointmentsListTask?.cancel()
        
         activityIndicator.startAnimating()
        
        let userinfo = Resource<AssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: getListOfAppointmentsURL, method: .get)
        
        
        self.appointmentsListService.fetch(params: userinfo.params, method: .get, url: getListOfAppointmentsURL) { (response, error) in
            if let mappedResponse = response
            {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                self.appointmentList = mappedResponse
                 // cell.setup(appointmentList[indexPath.row])
                 //self.assetTableCustomView.assetDelegate = self
                
            } else if error != nil {
                //controller.handleError(error)
                self.showErrorAlert(with: "error")
            }
        }
        
    }
    
    func handlePicker(sender: UIDatePicker) {
        var timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = timeFormatter.string(from: datePicker.date)
        fetchData(dateTime: strDate)
    }
    
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AppointmentsListViewController : AppointmentListDelegateProtocol{
    func getDevProfile(developer: UserDto) {
        
    }
    
    func EditAppointment(appointment: AppointmentDto) {
        let storyboard = UIStoryboard(name: "Appointments", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "AddAppointmentViewController") as? AddAppointmentViewController {
            viewController.getAppointmentModel(appointment: appointment)
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func cancelAppointment(appointment: AppointmentDto) {
        self.appointmentList.removeAll(where: {$0.id == appointment.id})
        self.appointmentsTableView.reloadData()
    }
    
}

