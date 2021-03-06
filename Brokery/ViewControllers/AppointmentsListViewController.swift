//
//  AppointmentsListViewController.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class AppointmentsListViewController: BaseViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var appointmentsTableView: UITableView!
    
    @IBOutlet var noDataLbl: UILabel!
    @IBOutlet var numberOfAppointmentsLbl: UILabel!
    @IBOutlet var appointmentDateLbl: UILabel!
    @IBOutlet var appointmentDayLbl: UILabel!
    
    private lazy var appointmentsListService = GetAppointmentsListService()
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var getappointmentsListTask: URLSessionDataTask!
    var appointmentList = [AppointmentDto]()
    var appointmentCardColor = false
    var appointmentDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appointmentsTableView.register(UINib(nibName: "AppointmentCard", bundle: nil), forCellReuseIdentifier: "AppointmentCard")
        datePicker.addTarget(self, action: #selector(handlePicker(sender:)), for: UIControl.Event.valueChanged)
        
        var timeFormatter = DateFormatter()
        timeFormatter.dateFormat = listDateTimeFormat
        let selectedDateTime = timeFormatter.string(from:  datePicker.date);
        
        appointmentDate = selectedDateTime
        showDatePicked()

        //appointmentDate = datePicker.date
        appointmentsTableView.dataSource = self
        appointmentsTableView.delegate = self
        
        
        if  let endDate =  Calendar.current.date(byAdding: .day, value: 1, to: datePicker.date)
        {
            let endDateTime = timeFormatter.string(from: endDate);
            fetchData(startDateTime: selectedDateTime , endDateTime: appointmentDate)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "Appointments")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfAppointmentsLbl.text = String(appointmentList.count ) + " Appointments"
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = appointmentsTableView.dequeueReusableCell(withIdentifier: "AppointmentCard", for: indexPath) as? AppointmentCard else {
            return UITableViewCell()
        }
        cell.setup(appointmentList[indexPath.row], coloredCard: appointmentCardColor)
        appointmentCardColor = !appointmentCardColor
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return self.appointmentList.count
       }


    // Set the spacing between sections
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 15
       }
    
    private func fetchData(startDateTime : String , endDateTime : String)
    {
        self.noDataLbl.isHidden = true

        getappointmentsListTask?.cancel()
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        var userinfo = Resource<[AppointmentDto] , CustomError>(jsonDecoder: JSONDecoder(), path: getListOfAppointmentsURL, method: .get)
        
        userinfo.params["start"] = startDateTime
        userinfo.params["end"] = endDateTime
        
        self.appointmentsListService.fetch(params: userinfo.params, method: .get, url: getListOfAppointmentsURL) { (response, error) in
            if let mappedResponse = response
            {
                self.appointmentList = mappedResponse
                DispatchQueue.main.async {
                    self.appointmentsTableView.isHidden = false
                    self.activityIndicator.stopAnimating()
                    if ( self.appointmentList.count > 0){
                        self.appointmentsTableView.reloadData()
                    }
                    else{
                        self.appointmentsTableView.isHidden = true
                        self.noDataLbl.isHidden = false
                    }
                }
                
            } else if error != nil {
                //controller.handleError(error)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showErrorAlert(with: "error")
                }
            }
        }
    }
    
    
    fileprivate func showDatePicked() {
        let dateComponents = NSCalendar.current.dateComponents([.year, .month, .day], from: self.datePicker.date)
        
        if let day = dateComponents.day , let month = dateComponents.month , let year = dateComponents.year{
            
            appointmentDayLbl.text = datePicker.date.dayOfWeek()
            appointmentDateLbl.text = String(day) + " " + String( DateFormatter().monthSymbols[month - 1]) + " " +  String (year)
        }
    }
    
    @objc  func handlePicker(sender: UIDatePicker) {
        var timeFormatter = DateFormatter()
        timeFormatter.dateFormat = listDateTimeFormat
        let selectedDateTime = timeFormatter.string(from:  datePicker.date);
        
        if  let endDate =  Calendar.current.date(byAdding: .day, value: 1, to: datePicker.date)
        {
            let endDateTime = timeFormatter.string(from: endDate);
            fetchData (startDateTime: selectedDateTime, endDateTime: endDateTime)
        }
        showDatePicked()
        
        
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

