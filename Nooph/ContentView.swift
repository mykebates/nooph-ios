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
    @State private var isSending = false
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isSidebarVisible.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .padding()
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(ScaleButtonStyle())
                    Spacer()
                    Text("Nooph")
                        .font(.headline)
                        .padding(.vertical)
                    Spacer()
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                        .foregroundColor(.clear)
                        .padding()
                }
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                // Scrollable content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(0..<30) { index in
                            Text("Item \(index)")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple.opacity(0.05))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                        }
                    }
                    .padding()
                }
                .scrollDismissesKeyboard(.immediately)
                Spacer(minLength: 0)
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    Divider()
                    HStack(spacing: 12) {
                        Button(action: {
                            print("Attach tapped")
                        }) {
                            Image(systemName: "paperclip")
                                .foregroundColor(.purple)
                                .padding(8)
                                .background(Color.purple.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .buttonStyle(ScaleButtonStyle())
                        TextField("Type a message...", text: $messageText)
                            .focused($isInputFocused)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                            .foregroundColor(.primary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isInputFocused = true
                            }
                        Button(action: {
                            withAnimation {
                                isSending = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                print("Send: \(messageText)")
                                messageText = ""
                                isSending = false
                                isInputFocused = false
                            }
                        }) {
                            Image(systemName: isSending ? "checkmark" : "paperplane.fill")
                                .foregroundColor(.white)
                                .padding(12)
                                .background(messageText.isEmpty ? Color.gray : Color.purple)
                                .clipShape(Circle())
                        }
                        .disabled(messageText.isEmpty)
                        .buttonStyle(ScaleButtonStyle())
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                }
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, y: -1)
            }
            
            // Dimmed background
            if isSidebarVisible {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
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
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSidebarVisible)
        }
        .onTapGesture {
            isInputFocused = false
        }
    }
}

// Custom button style for scale animation
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct Sidebar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Menu")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            Divider()
                .background(Color.purple.opacity(0.2))
            
            ForEach(["Home", "Profile", "Settings"], id: \.self) { item in
                Button(action: {
                    print("\(item) tapped")
                }) {
                    HStack {
                        Image(systemName: iconName(for: item))
                            .foregroundColor(.purple)
                        Text(item)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 2)
    }
    
    private func iconName(for item: String) -> String {
        switch item {
        case "Home": return "house.fill"
        case "Profile": return "person.fill"
        case "Settings": return "gear"
        default: return "circle"
        }
    }
}

#Preview {
    ContentView()
}
