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

int calls = 0;

function makeText() returns string {
    calls += 1;
    return "a😀b";
}

function firstChar(string text) returns string {
    foreach var char in text {
        return char;
    }
    return "empty";
}

public function main() {
    string text = "a😀b";
    foreach string:Char char in text {
        io:println(char); // @output a
                          // @output 😀
                          // @output b
    }

    foreach var char in "xy" {
        if char == "x" {
            continue;
        }
        string:Char verified = char;
        io:println(verified); // @output y
    }

    foreach string char in "" {
        io:println(char);
    }

    string collected = "";
    foreach var char in makeText() {
        collected += char;
    }
    io:println(calls, ":", collected); // @output 1:a😀b

    text = "abc";
    collected = "";
    foreach string char in text {
        text = "";
        collected += char;
    }
    io:println(collected); // @output abc

    (function () returns string:Char)[] captures = [];
    foreach var char in "a😀b" {
        if char == "😀" {
            continue;
        }
        captures.push(function () returns string:Char { return char; });
    }
    foreach var fn in captures {
        io:println(fn()); // @output a
                         // @output b
    }

    collected = "";
    foreach var outerChar in "ab" {
        foreach var inner in "xy" {
            if inner == "x" {
                continue;
            }
            collected += outerChar + inner;
            break;
        }
    }
    io:println(collected); // @output ayby

    int count = 0;
    foreach var _ in "e\u{301}" {
        count += 1;
    }
    io:println(count); // @output 2
    io:println(firstChar("😀a")); // @output 😀
    io:println(firstChar("")); // @output empty

    string longText = "😀";
    foreach int _ in 0 ..< 15 {
        longText += longText;
    }
    count = 0;
    foreach var _ in longText {
        count += 1;
    }
    io:println(count); // @output 32768
}
