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

package stringruntime

import (
	"unicode/utf8"

	"github.com/ballerina-nutcracker/ballerina/runtime"
	"github.com/ballerina-nutcracker/ballerina/runtime/extern"
	"github.com/ballerina-nutcracker/ballerina/semtypes"
	"github.com/ballerina-nutcracker/ballerina/values"
)

func initStringIterator(rt *runtime.Runtime) {
	const nextMethodName = "$stringIterator.next"
	env := rt.GetTypeEnv()
	recordDef := semtypes.NewMappingDefinition()
	recordTy := recordDef.Define(env,
		[]semtypes.Field{semtypes.FieldFrom("value", semtypes.Char, false, false)}, semtypes.Never)
	recordAtomicTy := semtypes.ToMappingAtomicType(semtypes.ContextFrom(env), recordTy)
	paramsDef := semtypes.NewListDefinition()
	params := paramsDef.Define(env, nil, semtypes.ListMutability(semtypes.CellMutabilityNone))
	nextDef := semtypes.NewFunctionDefinition()
	nextTy := nextDef.Define(env, params, semtypes.Union(recordTy, semtypes.Nil),
		semtypes.FunctionQualifiersFrom(env, true, false))
	iteratorDef := semtypes.NewObjectDefinition()
	iteratorTy := iteratorDef.Define(env, semtypes.ObjectQualifiersDefault, []semtypes.Member{{
		Name: "next", ValueType: nextTy, Kind: semtypes.MemberKindMethod, Visibility: semtypes.VisibilityPublic, Immutable: true,
	}})
	runtime.RegisterExternFunction(rt, orgName, moduleName, "iterator", func(_ *extern.Context, args []values.BalValue) (values.BalValue, error) {
		return values.NewObject(iteratorTy,
			map[string]values.BalValue{"remaining": args[0].(string)},
			map[string]string{"next": orgName + "/" + moduleName + ":" + nextMethodName}, nil, nil), nil
	})
	runtime.RegisterExternFunction(rt, orgName, moduleName, nextMethodName, func(_ *extern.Context, args []values.BalValue) (values.BalValue, error) {
		iterator := args[0].(*values.Object)
		value, _ := iterator.Get("remaining")
		remaining := value.(string)
		if remaining == "" {
			return nil, nil
		}
		char, size := utf8.DecodeRuneInString(remaining)
		iterator.Put("remaining", remaining[size:])
		return values.NewMap(recordTy, recordAtomicTy, false,
			[]values.MapEntry{{Key: "value", Value: string(char)}}), nil
	})
}
