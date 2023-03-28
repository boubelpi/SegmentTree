//
//  main.swift
//  SegmentTree
//
//  Created by Pavel Boubel on 27/03/23.
//

import Foundation

class lazy_segment_tree { //lazy segment tree
        var tre : [Int] //tre is our segment tree itself
        var pp : [Int] //pp contains number of operations of changing elements at segment
        let a : [Int] //a is array, used for build only
        init(_ tre : [Int],_ pp : [Int],_ a : [Int]) { //initializer (necessary for classes)
            self.tre = tre
            self.pp = pp
            self.a = a
        }
        func build(_ v : Int, _ tl : Int, _ tr : Int) { //using build function we build segment tree (array tre) from array a
            if (tl == tr) { //if the current node contains information about segment that contains only one element, then the sum of elements at this segment is equal to that element (a[tl], because for node v segment is [tl, tl])
             self.tre[v] = self.a[tl]
             return
            }
            let mid = (tl + tr) / 2
            //we divide segment to two: segment [tl, mid] and [mid + 1, tr], so nodes for these segments are numbered v * 2 and v * 2 + 1
            build(v * 2, tl, mid)
            build(v * 2 + 1, mid + 1, tr)
            self.tre[v] = self.tre[v * 2] + self.tre[v * 2 + 1] //because segment for node v is [tl, tr] we need to find the sum of elements at segments [tl, mid] and [mid + 1, tr]
        }
        func push (_ v : Int, _ len : Int) {
            if (self.pp[v] % 2 == 1) { //because for cases of even pp[v] there are no changes for segment
                self.tre[v] = len - self.tre[v] //because elements equal to either 0 or 1, maximum possible sum at this segment is equal to len
            }
            //because [tl, mid] and [mid + 1,tr] are subsegments of [tl, tr], we need to process operation of changing elements for pp[v] times also at these segments
            self.pp[v * 2] += self.pp[v]
            self.pp[v * 2 + 1] += self.pp[v]
            self.pp[v] = 0  //now we completed operations for segment [tl, tr] and we don't need to make more operations, that's why we need to make pp[v] equal to 0
        }
        func update (_ v : Int, _ tl : Int, _ tr : Int, _ l : Int, _ r : Int) {
            if (tl > r || tr < l) {return} //if [l, r] is not subsegment of [tl, tr], then we don't have to check this segment
            if (tl == l && tr == r) { //if segment for node v is [tl, tr], that's equal to [l, r], then we need to change elements at this segment. So we should add 1 to pp[v] and the operation of changing elements will be completed when we need to check this segment again
                self.pp[v] += 1
                return
            }
            //now we change elements at segment [tl, tr] (if we need to change them, because pp[v] can also be even)
            push(v, tr - tl + 1)
            let mid = (tl + tr) / 2
            //go to segments [tl, mid] and [mid + 1, tr]
            update(v * 2, tl, mid, l, min(r, mid))
            update(v * 2 + 1, mid + 1, tr, max(l, mid + 1), r)
            //before updating tre[v] we need to update tre[v * 2] and tre[v * 2 + 1] if we need to do this
            push(v * 2, mid - tl + 1)
            push(v * 2 + 1, tr - mid)
            //update tre[v]
            self.tre[v] = self.tre[v * 2] + self.tre[v * 2 + 1]
        }
};

let n : Int = 3 //TODO : read from console
var nums1 = Array(repeating : 0, count : 0) //statement
var nums2 = Array(repeating : 0, count : 0) //statement
for i in 0...n - 1 {
    let x : Int = 1 - i % 2 //TODO : read from console
    nums1.append(x)
}
for _ in 0...n - 1 {
    let x : Int = 0 //TODO : read from console
    nums2.append(x)
}
let tre = Array(repeating : 0, count : 8 * n) //we create array tre, it must have the length of 8 * n (it can be 4 * n, then we need to check cases at segment tree itself
let pp = Array(repeating : 0, count : 8 * n) //create array pp, length of it should be equal to 8 * n (it can also be 4 * n)
var lst = lazy_segment_tree(tre, pp, nums1) //create segment tree (making a equal to nums1, tre and pp at segment tree now have size of 8 * n
lst.build(1, 0, n - 1) //we build segment tree
let queries = [[1, 1, 1], [2, 1, 0], [3, 0, 0]] //statement
var sum = 0 //the current sum of elements of nums2
var ans = Array(repeating : 0, count : 0) //we keep answers for queries
for t in queries { //coming through queries
    let type = t[0]
    if (type == 1) {
        let left = t[1]
        let right = t[2]
        //if the type of query is equal to 1, then we need to change the elements at segment [left, right], so we use function update to do this at segment tree
        lst.update(1, 0, n - 1, left, right)
    }
    else if (type == 2) {
        let p = t[1]
        sum += p * lst.tre[1] //sum of all elements of array is node which has number 1, that's we we can deal without function get; because elements can be equal only to 0 or 1, it's easy to notice, that the sum of multiplication each element to p is equal to multiplication the sum of elements and p
    }
    else {
        ans.append(sum) //the type of query is equal to 3, so we support the sum of elements of nums2 at sum
    }
}
print(ans)

/*
 The task is: you have two array nums1 and nums2 of length n (n is not more than 1e5), it's known that elements of array nums1 are equal either to 0 or 1. There are some queries (not more than 1e5), there are three types of queries:
 - first type: you are given segment [left, right], you need to change each element of array nums1, that's equal to 0, to 1, and change each element, that's equal to 1, to 0.
 - second type: you are given the number p, you need to add to each element of array nums2 multiplication of nums1[i] (if we check nums2[i]) to p
 - third type: you should print the sum of elements of array nums2
 */

/*
 Let's make very important observation: because elements of array nums1 are equal either to 1 or 0 (and also because the queries of third type ask only for the sum of elements at the whole segment), we can find the sum of all elements and then find multiplication of it and p. So it's enough for third type of queries.
 Let's also make other observation: if the length of some segment of array nums1 is equal to len and the sum of elements of array nums1 at this segment is equal to sum, then after completing the query of the first type we get that the sum of elements at this segment will be equal to len - sum.
 These observations lead to the final solution of the task: we can have lazy segment tree, that will complete the queries of the first type and that will help us to complete the queries of the second type (we will use only one element of that segment tree, just because we need to find the sum at the whole array). So, using segment tree, we get solution that runs on time for O(nlogn).
 */
