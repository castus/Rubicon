//
//  VarDeclarationTypeTests.swift
//  Rubicon
//
//  Created by Kryštof Matěj on 22/04/2017.
//  Copyright © 2017 Kryštof Matěj. All rights reserved.
//

import XCTest

class VarDeclarationTypeParserTests: XCTestCase {

    func test_givenNoToken_whenParse_thenThrowError() {
        do {
            let parser = VarDeclarationTypeParser()
            _ = try parser.parse(tokens: [])
        } catch {
            return
        }

        XCTFail()
    }

    func test_givenVariableToken_whenParse_thenThrowError() {
        do {
            let parser = VarDeclarationTypeParser()
            _ = try parser.parse(tokens: [.variable])
        } catch {
            return
        }

        XCTFail()
    }

    func test_givenMissingColonToken_whenParse_thenThrowError() {
        let tokens: [Token] = [.variable, .identifier(name: "x"), .identifier(name: "Int")]
        do {
            let parser = VarDeclarationTypeParser()
            _ = try parser.parse(tokens: tokens)
        } catch {
            return
        }

        XCTFail()
    }

    func test_givenInvalidTokens1_whenParse_thenThrowError() {
        let tokens: [Token] = [.constant, .identifier(name: "x"), .colon, .identifier(name: "Int"), .leftCurlyBracket, .get, .rightCurlyBracket]
        do {
            let parser = VarDeclarationTypeParser()
            _ = try parser.parse(tokens: tokens)
        } catch {
            return
        }

        XCTFail()
    }

    func test_givenInvalidTokens2_whenParse_thenThrowError() {
        let tokens: [Token] = [.variable, .identifier(name: "Int"), .variable, .identifier(name: "Int"), .leftCurlyBracket, .get, .rightCurlyBracket]
        do {
            let parser = VarDeclarationTypeParser()
            _ = try parser.parse(tokens: tokens)
        } catch {
            return
        }

        XCTFail()
    }

    func test_givenInvalidTokens3_whenParse_thenThrowError() {
        let tokens: [Token] = [.variable, .identifier(name: "Int"), .colon, .identifier(name: "Int"), .variable, .get, .rightCurlyBracket]
        do {
            let parser = VarDeclarationTypeParser()
            _ = try parser.parse(tokens: tokens)
        } catch {
            return
        }

        XCTFail()
    }

    func test_givenInvalidTokens4_whenParse_thenThrowError() {
        let tokens: [Token] = [.variable, .identifier(name: "Int"), .colon, .identifier(name: "Int"), .leftCurlyBracket, .get, .variable]
        do {
            let parser = VarDeclarationTypeParser()
            _ = try parser.parse(tokens: tokens)
        } catch {
            return
        }

        XCTFail()
    }

    func test_givenConstantDefinition_whenParse_thenParseVariable() {
        let tokens: [Token] = [.variable, .identifier(name: "x"), .colon, .identifier(name: "Int"), .leftCurlyBracket, .get, .rightCurlyBracket]

        do {
            let parser = VarDeclarationTypeParser()
            let result = try parser.parse(tokens: tokens)
            let type = result.varDeclarationType
            XCTAssertEqual(type.isConstant, true)
            XCTAssertEqual(type.identifier, "x")
            XCTAssertEqual(type.type, "Int")
        } catch {
            XCTFail()
        }
    }

    func test_givenVariableDefinition_whenParse_thenParseVariable() {
        let tokens: [Token] = [.variable, .identifier(name: "x"), .colon, .identifier(name: "Int"), .leftCurlyBracket, .get, .set, .rightCurlyBracket]

        do {
            let parser = VarDeclarationTypeParser()
            let result = try parser.parse(tokens: tokens)
            let type = result.varDeclarationType
            XCTAssertEqual(type.isConstant, false)
            XCTAssertEqual(type.identifier, "x")
            XCTAssertEqual(type.type, "Int")
            XCTAssertEqual(type.isOptional, false)
        } catch {
            XCTFail()
        }
    }

    func test_givenVariableDefinition2_whenParse_thenParseVariable() {
        let tokens: [Token] = [.variable, .identifier(name: "x"), .colon, .identifier(name: "Int"), .leftCurlyBracket, .set, .get, .rightCurlyBracket]

        do {
            let parser = VarDeclarationTypeParser()
            let result = try parser.parse(tokens: tokens)
            let type = result.varDeclarationType
            XCTAssertEqual(type.isConstant, false)
            XCTAssertEqual(type.identifier, "x")
            XCTAssertEqual(type.type, "Int")
            XCTAssertEqual(type.isOptional, false)
        } catch {
            XCTFail()
        }
    }

    func test_givenVariableDefinitionWithoutGet_whenParse_thenParseVariable() {
        let tokens: [Token] = [.variable, .identifier(name: "x"), .colon, .identifier(name: "Int"), .leftCurlyBracket, .set, .rightCurlyBracket]

        do {
            let parser = VarDeclarationTypeParser()
            _ = try parser.parse(tokens: tokens)
        } catch {
            return
        }
        XCTFail()
    }

    func test_givenOptionVariableDefinition_whenParse_thenParseVariable() {
        let tokens: [Token] = [.variable, .identifier(name: "x"), .colon, .identifier(name: "Int"), .questionMark, .leftCurlyBracket, .set, .get, .rightCurlyBracket]

        do {
            let parser = VarDeclarationTypeParser()
            let result = try parser.parse(tokens: tokens)
            let type = result.varDeclarationType
            XCTAssertEqual(type.isConstant, false)
            XCTAssertEqual(type.identifier, "x")
            XCTAssertEqual(type.type, "Int")
            XCTAssertEqual(type.isOptional, true)
            XCTAssertEqual(result.unparsedTokens, [])
        } catch {
            XCTFail()
        }
    }


    func test_givenAlotOfTokensDefinition_whenParse_thenParseVariable() {
        let tokens: [Token] = [.variable, .identifier(name: "x"), .colon, .identifier(name: "Int"), .questionMark, .leftCurlyBracket, .set, .get, .rightCurlyBracket, .leftCurlyBracket, .set, .get, .rightCurlyBracket]

        do {
            let parser = VarDeclarationTypeParser()
            let result = try parser.parse(tokens: tokens)
            let type = result.varDeclarationType
            XCTAssertEqual(type.isConstant, false)
            XCTAssertEqual(type.identifier, "x")
            XCTAssertEqual(type.type, "Int")
            XCTAssertEqual(type.isOptional, true)
            XCTAssertEqual(result.unparsedTokens, [.leftCurlyBracket, .set, .get, .rightCurlyBracket])
        } catch {
            XCTFail()
        }
    }

}