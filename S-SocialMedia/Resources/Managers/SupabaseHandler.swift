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
        supabaseURL: .init(string: "")!,
        supabaseKey: ""
    )
    
    var auth: AuthClient {
        supabaseClient.auth
    }
    
    var supabase: SupabaseClient {
        supabaseClient
    }
    
    private init() { }
}
