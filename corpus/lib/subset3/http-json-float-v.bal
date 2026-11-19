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

import ballerina/http;
import ballerina/io;

public function main() returns error? {
    // An integral float keeps its fraction in a JSON payload, as toJsonString writes it,
    // so the reader gets a non-int number back.
    http:Response res = new;
    res.setJsonPayload({value: 10.0});
    io:println(check res.getTextPayload()); // @output {"value":10.0}
    json resPayload = check res.getJsonPayload();
    json resValue = check resPayload.value;
    io:println(resValue is int); // @output false

    http:Request req = new;
    req.setJsonPayload([10.0, -0.0, 2.5, 1e20]);
    io:println(check req.getTextPayload()); // @output [10.0,-0.0,2.5,1e20]

    // setPayload with a json value takes the same encoder.
    http:Response resAny = new;
    resAny.setPayload({value: 10.0});
    io:println(check resAny.getTextPayload()); // @output {"value":10.0}
}
