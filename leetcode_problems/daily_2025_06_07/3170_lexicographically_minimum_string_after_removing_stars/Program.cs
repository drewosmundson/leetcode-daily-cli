/*
 * LeetCode Daily Challenge - 2025-06-07
 * Problem #3170: Lexicographically Minimum String After Removing Stars
 * Difficulty: Medium
 * Link: https://leetcode.com/problems/lexicographically-minimum-string-after-removing-stars/
 * 
 * You are given a string s. It may contain any number of '*' characters. Your 
 * task is to remove all '*' characters.
 * While there is a '*', do the following operation:
 * Delete the leftmost '*' and the smallest non-'*' character to its left. If 
 * there are several smallest characters, you can delete any of them.
 * Return the lexicographically smallest resulting string after removing all 
 * '*' characters.
 * 
 * Example 1:
 * Input: s = "aaba*"
 * Output: "aab"
 * Explanation:
 * We should delete one of the 'a' characters with '*'. If we choose s[3], s 
 * becomes the lexicographically smallest.
 * Example 2:
 * Input: s = "abc"
 * Output: "abc"
 * Explanation:
 * There is no '*' in the string.
 * 
 * Constraints:
 * 1 <= s.length <= 105
 * s consists only of lowercase English letters and '*'.
 * The input is generated such that it is possible to delete all '*' characters.
 */

using System;
using System.Collections.Generic;
using System.Linq;

public class Solution 
{
    public string lexicographicallyMinimumStringAfterRemovingStars() 
    {
        // TODO: Implement solution
        return default(string);
    }
}

class Program 
{
    static void Main() 
    {
        Solution solution = new Solution();
        
        // TODO: Add test cases
    }
}
// TODO: Add execution output below
// ========== EXECUTION OUTPUT ==========
// cd "3170_lexicographically_minimum_string_after_removing_stars"
// dotnet run
// ======================================
