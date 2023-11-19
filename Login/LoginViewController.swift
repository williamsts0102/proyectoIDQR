//
//  LoginViewController.swift
//  proyectoIDQR
//
//  Created by DAMII on 19/11/23.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnLogin(_ sender: UIButton) {
        // Verifica que los campos de usuario y contraseña no estén vacíos
                guard let username = tfUsername.text, !username.isEmpty,
                      let password = tfPassword.text, !password.isEmpty else {
                    // Muestra un mensaje de error si los campos están vacíos
                    showAlert(message: "Ingresa el usuario y la contraseña.")
                    return
                }

                // Realiza la autenticación
                authenticateUser(username: username, password: password)
        
    }
    
    func authenticateUser(username: String, password: String) {
            let parameters: [String: Any] = ["username": username, "password": password]

            AF.request("URL_DE_TU_API", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                .responseDecodable(of: User.self) { response in
                    switch response.result {
                    case .success(let user):
                        self.handleAuthenticationSuccess(user: user)
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        self.handleAuthenticationFailure()
                    }
                }
        }

        func handleAuthenticationSuccess(user: User) {
            print("Usuario autenticado con éxito. ID: \(user.id), Rol: \(user.role)")
            // Aquí puedes realizar acciones adicionales según el rol del usuario.

            // Por ejemplo, puedes navegar a la vista de generación de QR para los alumnos o la vista de escaneo de QR para los vigilantes.
            // Asegúrate de tener un identificador de segue configurado en tu storyboard.
            self.performSegue(withIdentifier: "nombreDeTuSegue", sender: self)
        }

        func handleAuthenticationFailure() {
            showAlert(message: "La autenticación falló. Verifica tus credenciales.")
        }

        func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
}
