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

package opaque

import (
	"github.com/ballerina-nutcracker/ballerina/ast"
	"github.com/ballerina-nutcracker/ballerina/model"
	"github.com/ballerina-nutcracker/ballerina/semtypes"
	"github.com/ballerina-nutcracker/ballerina/tools/diagnostics"
)

func stringIterator(ctx *Context, owner cacheOwner, resolve Resolve, materialize Materialize,
	semanticError SemanticError, _ bool, args []ast.BLangExpression,
	_ semtypes.SemType, pos diagnostics.Location) (model.SymbolRef, bool) {
	if len(args) == 0 {
		semanticError("missing container argument", pos)
		return model.SymbolRef{}, false
	}
	containerTy, ok := resolve(args[0], semtypes.String)
	if !ok {
		return model.SymbolRef{}, false
	}
	if !semtypes.IsSubtype(ctx.typeContext(), containerTy, semtypes.String) {
		semanticError("expect first argument to be a subtype of string", pos)
		return model.SymbolRef{}, false
	}
	if ref, found := ctx.lookupMono(owner, semtypes.String); found {
		return ref, true
	}
	env := ctx.typeEnv()
	recordDef := semtypes.NewMappingDefinition()
	recordTy := recordDef.Define(env, []semtypes.Field{semtypes.FieldFrom("value", semtypes.Char, false, false)}, semtypes.Never)
	paramsDef := semtypes.NewListDefinition()
	params := paramsDef.Define(env, nil, semtypes.ListMutability(semtypes.CellMutabilityNone))
	nextDef := semtypes.NewFunctionDefinition()
	nextTy := nextDef.Define(env, params, semtypes.Union(recordTy, semtypes.Nil), semtypes.FunctionQualifiersFrom(env, true, false))
	iteratorDef := semtypes.NewObjectDefinition()
	iteratorTy := iteratorDef.Define(env, semtypes.ObjectQualifiersDefault, []semtypes.Member{{
		Name: "next", ValueType: nextTy, Kind: semtypes.MemberKindMethod, Visibility: semtypes.VisibilityPublic, Immutable: true,
	}})
	ref, ok := materialize(model.TypedFunctionSignature{
		ParamTypes:    []semtypes.SemType{semtypes.String},
		RestParamType: semtypes.Never,
		ReturnType:    iteratorTy,
		Flags:         model.FuncSymbolFlagIsolated,
	})
	if !ok {
		return model.SymbolRef{}, false
	}
	ctx.storeMono(owner, ref, semtypes.String)
	return ref, true
}
