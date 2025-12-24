//
//  Dictionary.swift
//  Music Player
//
//  Created by apple on 24/12/25.
//

import SwiftUI
import WebKit

let dictionaryUrl = "https://react-ai-experiments.vercel.app/dictionary"
//let dictionaryUrl = "http://192.168.1.4:5173/dictionary"

struct DictionaryView: View {
    @State private var isDictionaryReady = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            WebView(
                url: URL(string: dictionaryUrl)!,
                onEvent: { event in
                    guard let type = event["type"] as? String else { return }
                    let body = event["body"] as? [String: Any] ?? [:]

                    switch type {
                    case "dictionary.ready":
                        isDictionaryReady = true

                    case "dictionary.error":
                        let message = body["message"] as? String ?? "Unknown error"
                        print("Dictionary error:", message)

                    default:
                        break
                    }
                }
            )
            .ignoresSafeArea()
            .opacity(isDictionaryReady ? 1 : 0)

            if !isDictionaryReady {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
                    .scaleEffect(1.2)
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    let onEvent: ([String: Any]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "webEvent")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear

        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKScriptMessageHandler {
        let parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func userContentController(_ userContentController: WKUserContentController,
                                   didReceive message: WKScriptMessage) {

            guard message.name == "webEvent" else { return }

            if let dict = message.body as? [String: Any] {
                DispatchQueue.main.async {
                    self.parent.onEvent(dict)
                }
            }
        }
    }
}

#Preview {
    DictionaryView()
}
