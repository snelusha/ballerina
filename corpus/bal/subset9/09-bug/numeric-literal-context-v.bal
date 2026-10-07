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

type DecimalRecord record {|
    decimal value;
|};

public function main() {
    decimal value = 99999999999999999999;
    io:println(value); // @output 99999999999999999999
    io:println(value == 99999999999999999999d); // @output true

    decimal[] list = [1.50, 12345678901234567890.123];
    io:println(list); // @output [1.50,12345678901234567890.123]

    map<decimal> mapping = {value: 1.50};
    io:println(mapping); // @output {"value":1.50}

    DecimalRecord decimalRecord = {value: 2.500};
    io:println(decimalRecord); // @output {"value":2.500}
}
