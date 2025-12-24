//
//  Dictionary.swift
//  Music Player
//
//  Created by apple on 24/12/25.
//

import SwiftUI
import WebKit
struct DictionaryView: View {
    var body: some View {
        WebView(url: URL(string: "https://react-ai-experiments.vercel.app/dictionary")!)
            .ignoresSafeArea()
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No update needed
    }
}

#Preview {
    DictionaryView()
}
