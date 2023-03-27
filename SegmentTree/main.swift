//
//  main.swift
//  SegmentTree
//
//  Created by Pavel Boubel on 27/03/23.
//

import Foundation

class lazy_segment_tree {
        var tre : [Int]
        var pp : [Int]
        let a : [Int] 
        init(_ tre : [Int],_ pp : [Int],_ a : [Int]) {
            self.tre = tre
            self.pp = pp
            self.a = a
        }
        func build(_ v : Int, _ tl : Int, _ tr : Int) {
            if (tl == tr) {
             self.tre[v] = self.a[tl]
             return
            }
            let mid = (tl + tr) / 2
            build(v * 2, tl, mid)
            build(v * 2 + 1, mid + 1, tr)
            self.tre[v] = self.tre[v * 2] + self.tre[v * 2 + 1]
        }
        func push (_ v : Int, _ len : Int) {
            if (self.pp[v] % 2 == 1) {
                self.tre[v] = len - self.tre[v]
            }
            self.pp[v * 2] += self.pp[v]
            self.pp[v * 2 + 1] += self.pp[v]
            self.pp[v] = 0
        }
        func update (_ v : Int, _ tl : Int, _ tr : Int, _ l : Int, _ r : Int) {
            if (tl > r || tr < l) {return}
            if (tl == l && tr == r) {
                self.pp[v] += 1
                return
            }
            push(v, tr - tl + 1)
            let mid = (tl + tr) / 2
            update(v * 2, tl, mid, l, min(r, mid))
            update(v * 2 + 1, mid + 1, tr, max(l, mid + 1), r)
            push(v * 2, mid - tl + 1)
            push(v * 2 + 1, tr - mid)
            self.tre[v] = self.tre[v * 2] + self.tre[v * 2 + 1]
        }
};

let n : Int = 3 //TODO : read from console
var nums1 = Array(repeating : 0, count : 0)
var nums2 = Array(repeating : 0, count : 0)
for i in 0...n - 1 {
    let x : Int = 1 - i % 2 //TODO : read from console
    nums1.append(x)
}
for _ in 0...n - 1 {
    let x : Int = 0 //TODO : read from console
    nums2.append(x)
}
let tre = Array(repeating : 0, count : 8 * n)
let pp = Array(repeating : 0, count : 8 * n)
var lst = lazy_segment_tree(tre, pp, nums1)
lst.build(1, 0, n - 1)
let queries = [[1, 1, 1], [2, 1, 0], [3, 0, 0]]
var sum = 0
var ans = Array(repeating : 0, count : 0)
for t in queries {
    let type = t[0]
    if (type == 1) {
        let left = t[1]
        let right = t[2]
        lst.update(1, 0, n - 1, left, right)
    }
    else if (type == 2) {
        let p = t[1]
        sum += p * lst.tre[1] //sum of all elements of array is node which has number 1
    }
    else {
        ans.append(sum)
    }
}
print(ans)
//TODO : add comments
