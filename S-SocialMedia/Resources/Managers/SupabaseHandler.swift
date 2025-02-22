//
//  SupabaseHandler.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/20/25.
//

import Supabase

final actor SupabaseHandler {
    static let shared = SupabaseHandler()
    
    private let supabaseClient = SupabaseClient(
        supabaseURL: .init(string: "https://idcvylwhbfaczprljyvy.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlkY3Z5bHdoYmZhY3pwcmxqeXZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg4OTgyNDEsImV4cCI6MjA1NDQ3NDI0MX0.tGnQBFhY4_aCjDIydx1__TEWii9KHQODGsbK1gRgpdQ"
    )
    
    var auth: AuthClient {
        supabaseClient.auth
    }
    
    var supabase: SupabaseClient {
        supabaseClient
    }
    
    private init() { }
}
