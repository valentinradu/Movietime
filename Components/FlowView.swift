//
//  FlowView.swift
//  Components
//
//  Created by Valentin Radu on 12/03/2020.
//  Copyright © 2020 Codewise Systems SRL. All rights reserved.
//

import SwiftUI

public struct SizePreferenceKeyData: Equatable {
    let selfSize: CGSize
    let parentSize: CGSize
    let item: AnyHashable
}

public struct SizePreferenceKey: PreferenceKey {
    public static var defaultValue: [SizePreferenceKeyData] = []
    public static func reduce(value: inout [SizePreferenceKeyData], nextValue: () -> [SizePreferenceKeyData]) {
        value.append(contentsOf: nextValue())
    }
}

private struct Layout {
    let offsets: [AnyHashable:CGSize]
    let size: CGSize
}

public struct FlowView<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Hashable, Content: View  {
    public var data: Data
    public var content: (Data.Element) -> Content

    @State private var layout: Layout? = nil

    private func updateLayout(prefs: [SizePreferenceKeyData]) {
        var breakPoint: CGSize = .zero
        var offsets: [AnyHashable:CGSize] = [:]
        var size: CGSize = .zero
        var line: [AnyHashable] = []
        let minPadding: CGFloat = 20
        for (i, pref) in prefs.enumerated() {
            let diff = pref.parentSize.width - breakPoint.width - pref.selfSize.width - minPadding
            if i != 0 && diff < 0 {
                let remainingSpace = pref.parentSize.width - breakPoint.width + minPadding
                for key in line {
                    offsets[key]?.width += remainingSpace / CGFloat(line.count)
                }
                breakPoint.height += pref.selfSize.height + minPadding
                breakPoint.width = 0
                offsets[pref.item] = breakPoint
                breakPoint.width += pref.selfSize.width + minPadding
                line = []
            }
            else {
                if (i != 0) {
                    line.append(pref.item)
                }
                offsets[pref.item] = breakPoint
                breakPoint.width += pref.selfSize.width + minPadding
            }
            size.width = max(breakPoint.width, size.width)
            size.height = max(breakPoint.height + pref.selfSize.height, size.height)
        }
        layout = Layout(offsets: offsets, size: size)
    }

    public init(data: Data, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack() {
                    ForEach(self.data, id: \.self) { item in
                        self.content(item)
                            .background(GeometryReader { bkgGeometry in
                                Rectangle()
                                    .fill(Color.white)
                                    .opacity(0)
                                    .preference(
                                        key: SizePreferenceKey.self,
                                        value: [SizePreferenceKeyData(
                                            selfSize: bkgGeometry.size,
                                            parentSize: geometry.size,
                                            item: AnyHashable(item))])
                            })
                            .offset(self.layout?.offsets[AnyHashable(item)] ?? .zero)
                    }.frame(width: geometry.size.width, height: self.layout?.size.height ?? 0, alignment: .topLeading)
                }
            }
        }
        .onPreferenceChange(SizePreferenceKey.self, perform: {
            self.updateLayout(prefs: $0)
        })
    }
}
