//
//  TouchIDAuthentication.swift
//  TouchMeIn
//
//  Created by Stanly Shiyanovskiy on 06.07.17.
//  Copyright © 2017 iT Guy Technologies. All rights reserved.
//

import Foundation
import LocalAuthentication

class TouchIDAuth {
    
    let context = LAContext()
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticateUser(completion: @escaping (String?) -> Void) { // Делаем авторизацию пользователя в блоке
        // Проверяем поддерживает ли устройство отпечаток пальца
        guard canEvaluatePolicy() else {
            completion("Touch ID not available")
            return
        }
        context.localizedFallbackTitle = ""
        // Если устройство поддерживает отпечаток, то пытаемся войти с помощью него
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Logging in with Touch ID") { (success, evaluateError) in
                                
                                // Обрабатываем ошибки попытки входа
                                if success {
                                    DispatchQueue.main.async {
                                        // User authenticated successfully, take appropriate action
                                        completion(nil)
                                    }
                                } else {
                                    
                                    let message: String
                                    switch evaluateError {
                                    case LAError.authenticationFailed?:
                                        message = "There was a problem verifying your identity."
                                    case LAError.userCancel?:
                                        message = "You pressed cancel."
                                    case LAError.userFallback?:
                                        message = "You pressed password."
                                    default:
                                        message = "Touch ID may not be configured"
                                    }
                                    
                                    completion(message)
                                }
        }
    }
}







