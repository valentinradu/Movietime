//
//  FlowView.swift
//  Components
//
//  Created by Valentin Radu on 12/03/2020.
//  Copyright © 2022 Valentin Radu. All rights reserved.
//

import SwiftUI

private struct SizePreferenceKeyData: Equatable {
    let selfSize: CGSize
    let parentSize: CGSize
    let item: AnyHashable
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: [SizePreferenceKeyData] = []
    static func reduce(value: inout [SizePreferenceKeyData], nextValue: () -> [SizePreferenceKeyData]) {
        value.append(contentsOf: nextValue())
    }
}

private struct Layout {
    let offsets: [AnyHashable: CGSize]
    let size: CGSize
}

struct FlowView<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Hashable, Content: View {
    var data: Data
    var content: (Data.Element) -> Content

    @State private var layout: Layout? = nil

    private func updateLayout(prefs: [SizePreferenceKeyData]) {
        var breakPoint: CGSize = .zero
        var offsets: [AnyHashable: CGSize] = [:]
        var size: CGSize = .zero
        var line: [AnyHashable] = []
        var extraSpace: CGFloat = 0
        let minPadding: CGFloat = 20
        for (i, pref) in prefs.enumerated() {
            let diff = pref.parentSize.width - breakPoint.width - pref.selfSize.width - minPadding
            if i != 0, diff < 0 {
                let remainingSpace = pref.parentSize.width - breakPoint.width + minPadding
                extraSpace = remainingSpace / CGFloat(line.count)
                for (j, key) in line.enumerated() {
                    offsets[key]?.width += extraSpace * CGFloat(j + 1)
                }
                breakPoint.height += pref.selfSize.height + minPadding
                breakPoint.width = 0
                offsets[pref.item] = breakPoint
                breakPoint.width += pref.selfSize.width + minPadding
                line = []
            } else {
                if i != 0 {
                    line.append(pref.item)
                }
                offsets[pref.item] = breakPoint
                breakPoint.width += pref.selfSize.width + minPadding
            }
            size.width = max(breakPoint.width, size.width)
            size.height = max(breakPoint.height + pref.selfSize.height, size.height)
        }

        for (j, key) in line.enumerated() {
            offsets[key]?.width += extraSpace * CGFloat(j + 1)
        }
        layout = Layout(offsets: offsets, size: size)
    }

    init(data: Data, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    ForEach(data, id: \.hashValue) { item in
                        content(item)
                            .background(GeometryReader { bkgGeometry in
                                Rectangle()
                                    .fill(Color.white)
                                    .opacity(0)
                                    .preference(
                                        key: SizePreferenceKey.self,
                                        value: [SizePreferenceKeyData(
                                            selfSize: bkgGeometry.size,
                                            parentSize: geometry.size,
                                            item: AnyHashable(item)
                                        )]
                                    )
                            })
                            .offset(layout?.offsets[AnyHashable(item)] ?? .zero)
                    }
                }
                .frame(width: geometry.size.width,
                       height: layout?.size.height ?? 0,
                       alignment: .topLeading)
            }
        }
        .onPreferenceChange(SizePreferenceKey.self, perform: {
            updateLayout(prefs: $0)
        })
    }
}
