//
//  SupabaseHandler.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/20/25.
//

import Supabase

final actor SupabaseHandler {
    static let shared = SupabaseHandler()
    
    let supabase = SupabaseClient(
        supabaseURL: .init(string: "")!,
        supabaseKey: ""
    )
    
    var auth: AuthClient {
        supabase.auth
    }
    
    private init() { }
}
