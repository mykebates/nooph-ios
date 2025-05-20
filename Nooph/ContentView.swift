//
//  ContentView.swift
//  nooph
//
//  Created by Myke Bates on 5/19/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isSidebarVisible = false
    @State private var messageText = ""
    
    var body: some View {
        ZStack {
            // Main layout
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        withAnimation {
                            isSidebarVisible.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                            .padding()
                    }
                    Spacer()
                    Text("Header")
                        .font(.headline)
                        .padding(.vertical)
                    Spacer()
                    // Invisible spacer to balance layout
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                        .foregroundColor(.clear)
                        .padding()
                }
                .background(Color(.systemGray6))
                
                // Scrollable content
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(0..<30) { index in
                            Text("Item \(index)")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                
                Spacer(minLength: 0)
            }
            .blur(radius: isSidebarVisible ? 3 : 0)
            
            // Message Input Footer
            VStack {
                Spacer()
                HStack(spacing: 12) {
                    // Attachment icon
                    Button(action: {
                        print("Attach tapped")
                    }) {
                        Image(systemName: "paperclip")
                            .foregroundColor(.purple)
                    }
                    
                    // Text field
                    TextField("Type a message...", text: $messageText)
                        .padding(10)
                        .background(Color.purple.opacity(0.05))
                        .cornerRadius(10)
                        .foregroundColor(.primary)
                    
                    // Send button
                    Button(action: {
                        print("Send: \(messageText)")
                        messageText = ""
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.purple)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding()
                .background(Color(.systemGray6))
            }
            .ignoresSafeArea(edges: .bottom)
            
            // Dimmed background
            if isSidebarVisible {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isSidebarVisible = false
                        }
                    }
            }
            
            // Sidebar
            HStack {
                Sidebar()
                    .frame(width: 250)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
                
                Spacer()
            }
            .offset(x: isSidebarVisible ? 0 : -300)
            .animation(.easeInOut, value: isSidebarVisible)
        }
    }
}

struct Sidebar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Sidebar")
                .font(.title)
                .padding(.top, 50)
            Divider()
            Text("Home")
            Text("Profile")
            Text("Settings")
            Spacer()
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color(UIColor.systemGray5))
    }
}

#Preview {
    ContentView()
}
