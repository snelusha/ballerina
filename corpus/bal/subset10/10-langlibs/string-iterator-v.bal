// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;

public function main() {
    var iterator = "é😀".iterator();
    record {| string:Char value; |}? first = iterator.next();
    if first != () {
        io:println(first.value); // @output é
    }
    var second = iterator.next();
    if second != () {
        string:Char char = second.value;
        io:println(char); // @output 😀
    }
    io:println(iterator.next() == (), iterator.next() == ()); // @output truetrue

    var empty = string:iterator(str = "");
    io:println(empty.next() == (), empty.next() == ()); // @output truetrue

    var left = string:iterator("ab");
    var right = "ab".iterator();
    _ = left.next();
    var rightFirst = right.next();
    if rightFirst != () {
        io:println(rightFirst.value); // @output a
    }
    var leftSecond = left.next();
    if leftSecond != () {
        io:println(leftSecond.value); // @output b
    }

    var nul = "\u{0}".iterator().next();
    if nul != () {
        io:println(nul.value == "\u{0}"); // @output true
    }
}
