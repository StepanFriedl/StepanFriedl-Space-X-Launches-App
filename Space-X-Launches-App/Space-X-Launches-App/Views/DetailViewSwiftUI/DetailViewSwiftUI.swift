//
//  DetailViewSwiftUI.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 16.09.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailViewSwiftUI: View {
    @ObservedObject var viewModel: DetailsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - Image
                if let imageUrl = viewModel.imageURL {
                    WebImage(url: imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .transition(.fade)
                }

                // MARK: - Launch Name
                Text(viewModel.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)

                // MARK: - Flight Number
                if let flightNumber = viewModel.flightNumber {
                    VStack (alignment: .leading, spacing: 8) {
                        Text("flightNumber".localized())
                            .font(.caption2)
                        
                        Text("\(flightNumber)")
                            .font(.body)
                    }
                }

                // MARK: - Launched Date
                if let launchedDate = viewModel.launched {
                    VStack (alignment: .leading, spacing: 8) {
                        Text("launched".localized())
                            .font(.caption2)
                        
                        Text("\(launchedDate.formatted())")
                            .font(.body)
                    }
                }

                // MARK: - Launch Success/Failure
                if let success = viewModel.success {
                    VStack (alignment: .leading, spacing: 8) {
                        Text("launchSuccess".localized())
                            .font(.caption2)
                        
                        Image(systemName: success ? "checkmark.circle" : "xmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundStyle(success ? .green : .red)
                    }
                }

                // MARK: - Failures
                if let failures = viewModel.failures,
                   failures.count > 0 {
                    VStack (alignment: .leading, spacing: 8) {
                        Text("failures".localized())
                            .font(.caption2)
                        
                        VStack (spacing: 2) {
                            ForEach(failures, id: \.self) { failure in
                                if let reason = failure.reason {
                                    HStack (alignment: .top) {
                                        Text("•")
                                        
                                        Text(reason)
                                            .font(.body)
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                
                // MARK: - Links
                if viewModel.isAnyLinkPresent() {
                    VStack (spacing: 8) {
                        Text("links".localized())
                            .font(.title2)
                        
                        HStack {
                            Spacer()
                            
                            if let youtubeLink = viewModel.youtubeLink {
                                linkButton(
                                    image: Image("youtube"),
                                    text: "youtube".localized(),
                                    action: youtubeLink.openInBrowser
                                )
                                
                                Spacer()
                            }
                            
                            if let articleLink = viewModel.articleLink {
                                linkButton(
                                    image: Image(systemName: "book.fill"),
                                    text: "article".localized(),
                                    action: articleLink.openInBrowser
                                )
                                
                                Spacer()
                            }
                            
                            if let wikiLink = viewModel.wikiLink {
                                linkButton(
                                    image: Image("wiki"),
                                    text: "wiki".localized(),
                                    action: wikiLink.openInBrowser
                                )
                                
                                Spacer()
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }
             }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.bottom, 100)
        }
        .navigationTitle("launchDetails".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func linkButton(image: Image, text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                
                Text(text)
            }
            .frame(width: 100)
        }
    }
    
}

#Preview {
    let viewModel = DetailsViewModel()
    
    return DetailViewSwiftUI(viewModel: viewModel)
}
