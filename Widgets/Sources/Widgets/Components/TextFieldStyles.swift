//
//  UnderlinedField.swift
//  Movietime
//
//  Created by Valentin Radu on 07/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

struct UnderlinedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack {
            configuration.padding(.horizontal, 10)
            Divider()
                .frame(height: 1)
                .background(Color.placeholder)
        }
    }
}
