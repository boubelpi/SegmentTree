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
