//
//  JaroWinkler.swift
//  
//
//  Created by ImIzaac on 11/5/17.
//

import Foundation

func jaroWinklerMatch(_ s: String, _ t: String) -> Double {
    let s_len: Int = s.count
    let t_len: Int = t.count
    
    if s_len == 0 && t_len == 0 {
        return 1.0
    }
    
    if s_len == 0 || t_len == 0 {
        return 0.0
    }
    
    var match_distance: Int = 0
    
    if s_len == 1 && t_len == 1 {
        match_distance = 1
    } else {
        match_distance = ([s_len, t_len].max()!/2) - 1
    }
    
    
    var s_matches = [Bool]()
    var t_matches = [Bool]()
    
    for _ in 1...s_len {
        s_matches.append(false)
    }
    
    for _ in 1...t_len {
        t_matches.append(false)
    }
    
    var matches: Double = 0.0
    var transpositions: Double = 0.0
    
    // iterate through all the items between the 0th and the s_len-1th number (which is the last)
    for i in 0...s_len-1 {
        
        // Only check for matches within these bounds
        // the first character, or i-match-distance (which is the furthest back in a string we are allowed to look)
        let start = [0, (i-match_distance)].max()!
        // i plus match distance or the last character in t
        let end = [(i + match_distance), t_len-1].min()!
        
        // if start is ever greater than end we're done
        if start > end {
            break
        }
        
        for j in start...end {
            
            if t_matches[j] {
                // This character has already been matched against
                continue
            }
            
            if s[String.Index.init(encodedOffset: i)] != t[String.Index.init(encodedOffset: j)] {
                // No character match
                continue
            }
            // We must have a match
            s_matches[i] = true
            t_matches[j] = true
            matches += 1
            break
        }
    }
    
    // if at this point we have no matches, then we are done.
    if matches == 0 {
        return 0.0
    }
    
    // Then we check for transpositions
    var k = 0
    for i in 0...s_len-1 {
        if !s_matches[i] {
            // if this letter has no match, then we don't care about it
            continue
        }
        while !t_matches[k] {
            // if it has a match in t_matches, we also don't care about, but we do want to know where the match is if there is one, so we iterate throguh t_matches looking for their indicies and tracking them with k
            k += 1
        }
        if s[String.Index.init(encodedOffset: i)] != t[String.Index.init(encodedOffset: k)] {
            
            transpositions += 1
        }
        
        k += 1
    }
    
    let top = (matches / Double(s_len)) + (matches / Double(t_len)) + (matches - (transpositions / 2)) / matches
    return top/3
}

extension String {
    func jaroWinkler(_ t: String) -> Double {
        return jaroWinklerMatch(self, t)
    }
}

extension Array where Iterator.Element == String {
    func jaroWinklerSort(byString t: String) -> [String] {
        return self.sorted(by: {$0.jaroWinkler(t) > $1.jaroWinkler(t)})
    }
}
