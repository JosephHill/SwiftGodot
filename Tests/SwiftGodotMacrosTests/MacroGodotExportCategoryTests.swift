//
//  MacroGodotExportGroupTests.swift
//  SwiftGodotMacrosTests
//
//  Created by Estevan Hernandez on 12/4/23.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SwiftGodotMacroLibrary

final class MacroGodotExportGroupTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "Godot": GodotMacro.self,
        "Export": GodotExport.self,
        "exportGroup": GodotMacroExportGroup.self
    ]
    
    func testGodotExportGroupWithPrefix() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    #exportGroup("Vehicle", prefix: "vehicle_")
    @Export var vehicle_make: String = "Mazda"
    @Export var vehicle_model: String = "RX7"
}
""",
            expandedSource:
"""

class Car: Node {
    var vehicle_make: String = "Mazda"

    func _mproxy_set_vehicle_make (args: [Variant]) -> Variant? {
    	vehicle_make = String (args [0])!
    	return nil
    }

    func _mproxy_get_vehicle_make (args: [Variant]) -> Variant? {
        return Variant (vehicle_make)
    }
    var vehicle_model: String = "RX7"

    func _mproxy_set_vehicle_model (args: [Variant]) -> Variant? {
    	vehicle_model = String (args [0])!
    	return nil
    }

    func _mproxy_get_vehicle_model (args: [Variant]) -> Variant? {
        return Variant (vehicle_model)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        classInfo.addPropertyGroup(name: "Vehicle", prefix: "vehicle_")
        let _pvehicle_make = PropInfo (
            propertyType: .string,
            propertyName: "vehicle_make",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_make", flags: .default, returnValue: _pvehicle_make, arguments: [], function: Car._mproxy_get_vehicle_make)
    	classInfo.registerMethod (name: "_mproxy_set_make", flags: .default, returnValue: nil, arguments: [_pvehicle_make], function: Car._mproxy_set_vehicle_make)
    	classInfo.registerProperty (_pvehicle_make, getter: "_mproxy_get_make", setter: "_mproxy_set_make")
        let _pvehicle_model = PropInfo (
            propertyType: .string,
            propertyName: "vehicle_model",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_model", flags: .default, returnValue: _pvehicle_model, arguments: [], function: Car._mproxy_get_vehicle_model)
    	classInfo.registerMethod (name: "_mproxy_set_model", flags: .default, returnValue: nil, arguments: [_pvehicle_model], function: Car._mproxy_set_vehicle_model)
    	classInfo.registerProperty (_pvehicle_model, getter: "_mproxy_get_model", setter: "_mproxy_set_model")
    } ()
}
""",
        macros: testMacros
        )
    }
    
    func testGodotExportGroupProducesPropertiesWithPrefixes_whenAllPropertiesAppearAfterexportGroup() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    #exportGroup("Vehicle")
    @Export var make: String = "Mazda"
    @Export var model: String = "RX7"
}
""",
   expandedSource:
"""

class Car: Node {
    var make: String = "Mazda"

    func _mproxy_set_make (args: [Variant]) -> Variant? {
    	make = String (args [0])!
    	return nil
    }

    func _mproxy_get_make (args: [Variant]) -> Variant? {
        return Variant (make)
    }
    var model: String = "RX7"

    func _mproxy_set_model (args: [Variant]) -> Variant? {
    	model = String (args [0])!
    	return nil
    }

    func _mproxy_get_model (args: [Variant]) -> Variant? {
        return Variant (model)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        classInfo.addPropertyGroup(name: "Vehicle", prefix: "")
        let _pmake = PropInfo (
            propertyType: .string,
            propertyName: "make",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_make", flags: .default, returnValue: _pmake, arguments: [], function: Car._mproxy_get_make)
    	classInfo.registerMethod (name: "_mproxy_set_make", flags: .default, returnValue: nil, arguments: [_pmake], function: Car._mproxy_set_make)
    	classInfo.registerProperty (_pmake, getter: "_mproxy_get_make", setter: "_mproxy_set_make")
        let _pmodel = PropInfo (
            propertyType: .string,
            propertyName: "model",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_model", flags: .default, returnValue: _pmodel, arguments: [], function: Car._mproxy_get_model)
    	classInfo.registerMethod (name: "_mproxy_set_model", flags: .default, returnValue: nil, arguments: [_pmodel], function: Car._mproxy_set_model)
    	classInfo.registerProperty (_pmodel, getter: "_mproxy_get_model", setter: "_mproxy_set_model")
    } ()
}
""",
   macros: testMacros
        )
    }
    
    func testGodotExportGroupOnlyProducesPropertiesWithPrefixes_whenPropertiesAppearAfterexportGroup() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    @Export var vin: String = "00000000000000000"
    #exportGroup("YMMS")
    @Export var year: Int = 1997
}
""",
            expandedSource:
"""


class Car: Node {
    var vin: String = "00000000000000000"

    func _mproxy_set_vin (args: [Variant]) -> Variant? {
    	vin = String (args [0])!
    	return nil
    }

    func _mproxy_get_vin (args: [Variant]) -> Variant? {
        return Variant (vin)
    }
    var year: Int = 1997

    func _mproxy_set_year (args: [Variant]) -> Variant? {
    	year = Int (args [0])!
    	return nil
    }

    func _mproxy_get_year (args: [Variant]) -> Variant? {
        return Variant (year)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        let _pvin = PropInfo (
            propertyType: .string,
            propertyName: "vin",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_vin", flags: .default, returnValue: _pvin, arguments: [], function: Car._mproxy_get_vin)
    	classInfo.registerMethod (name: "_mproxy_set_vin", flags: .default, returnValue: nil, arguments: [_pvin], function: Car._mproxy_set_vin)
    	classInfo.registerProperty (_pvin, getter: "_mproxy_get_vin", setter: "_mproxy_set_vin")
        classInfo.addPropertyGroup(name: "YMMS", prefix: "")
        let _pyear = PropInfo (
            propertyType: .int,
            propertyName: "year",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_year", flags: .default, returnValue: _pyear, arguments: [], function: Car._mproxy_get_year)
    	classInfo.registerMethod (name: "_mproxy_set_year", flags: .default, returnValue: nil, arguments: [_pyear], function: Car._mproxy_set_year)
    	classInfo.registerProperty (_pyear, getter: "_mproxy_get_year", setter: "_mproxy_set_year")
    } ()
}
""",
            macros: testMacros
        )
    }
    
    func testGodotExportGroupProducesPropertiesWithoutPrefixes_whenAllPropertiesAppearAfterexportGroup() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    @Export var vin: String = "00000000000000000"
    @Export var year: Int = 1997
    #exportGroup("Pointless")
}
""",
            expandedSource:
"""

class Car: Node {
    var vin: String = "00000000000000000"

    func _mproxy_set_vin (args: [Variant]) -> Variant? {
    	vin = String (args [0])!
    	return nil
    }

    func _mproxy_get_vin (args: [Variant]) -> Variant? {
        return Variant (vin)
    }
    var year: Int = 1997

    func _mproxy_set_year (args: [Variant]) -> Variant? {
    	year = Int (args [0])!
    	return nil
    }

    func _mproxy_get_year (args: [Variant]) -> Variant? {
        return Variant (year)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        let _pvin = PropInfo (
            propertyType: .string,
            propertyName: "vin",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_vin", flags: .default, returnValue: _pvin, arguments: [], function: Car._mproxy_get_vin)
    	classInfo.registerMethod (name: "_mproxy_set_vin", flags: .default, returnValue: nil, arguments: [_pvin], function: Car._mproxy_set_vin)
    	classInfo.registerProperty (_pvin, getter: "_mproxy_get_vin", setter: "_mproxy_set_vin")
        let _pyear = PropInfo (
            propertyType: .int,
            propertyName: "year",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_year", flags: .default, returnValue: _pyear, arguments: [], function: Car._mproxy_get_year)
    	classInfo.registerMethod (name: "_mproxy_set_year", flags: .default, returnValue: nil, arguments: [_pyear], function: Car._mproxy_set_year)
    	classInfo.registerProperty (_pyear, getter: "_mproxy_get_year", setter: "_mproxy_set_year")
        classInfo.addPropertyGroup(name: "Pointless", prefix: "")
    } ()
}
""",
            macros: testMacros
        )
    }
    
    func testGodotExportGroupProducesPropertiesWithDifferentPrefixes_whenPropertiesAppearAfterDifferentexportGroup() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    #exportGroup("VIN")
    @Export var vin: String = ""
    #exportGroup("YMM")
    @Export var year: Int = 1997
    @Export var make: String = "HONDA"
    @Export var model: String = "ACCORD"
    
}
""",
            expandedSource:
"""

class Car: Node {
    var vin: String = ""

    func _mproxy_set_vin (args: [Variant]) -> Variant? {
    	vin = String (args [0])!
    	return nil
    }

    func _mproxy_get_vin (args: [Variant]) -> Variant? {
        return Variant (vin)
    }
    var year: Int = 1997

    func _mproxy_set_year (args: [Variant]) -> Variant? {
    	year = Int (args [0])!
    	return nil
    }

    func _mproxy_get_year (args: [Variant]) -> Variant? {
        return Variant (year)
    }
    var make: String = "HONDA"

    func _mproxy_set_make (args: [Variant]) -> Variant? {
    	make = String (args [0])!
    	return nil
    }

    func _mproxy_get_make (args: [Variant]) -> Variant? {
        return Variant (make)
    }
    var model: String = "ACCORD"

    func _mproxy_set_model (args: [Variant]) -> Variant? {
    	model = String (args [0])!
    	return nil
    }

    func _mproxy_get_model (args: [Variant]) -> Variant? {
        return Variant (model)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        classInfo.addPropertyGroup(name: "VIN", prefix: "")
        let _pvin = PropInfo (
            propertyType: .string,
            propertyName: "vin",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_vin", flags: .default, returnValue: _pvin, arguments: [], function: Car._mproxy_get_vin)
    	classInfo.registerMethod (name: "_mproxy_set_vin", flags: .default, returnValue: nil, arguments: [_pvin], function: Car._mproxy_set_vin)
    	classInfo.registerProperty (_pvin, getter: "_mproxy_get_vin", setter: "_mproxy_set_vin")
        classInfo.addPropertyGroup(name: "YMM", prefix: "")
        let _pyear = PropInfo (
            propertyType: .int,
            propertyName: "year",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_year", flags: .default, returnValue: _pyear, arguments: [], function: Car._mproxy_get_year)
    	classInfo.registerMethod (name: "_mproxy_set_year", flags: .default, returnValue: nil, arguments: [_pyear], function: Car._mproxy_set_year)
    	classInfo.registerProperty (_pyear, getter: "_mproxy_get_year", setter: "_mproxy_set_year")
        let _pmake = PropInfo (
            propertyType: .string,
            propertyName: "make",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_make", flags: .default, returnValue: _pmake, arguments: [], function: Car._mproxy_get_make)
    	classInfo.registerMethod (name: "_mproxy_set_make", flags: .default, returnValue: nil, arguments: [_pmake], function: Car._mproxy_set_make)
    	classInfo.registerProperty (_pmake, getter: "_mproxy_get_make", setter: "_mproxy_set_make")
        let _pmodel = PropInfo (
            propertyType: .string,
            propertyName: "model",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_model", flags: .default, returnValue: _pmodel, arguments: [], function: Car._mproxy_get_model)
    	classInfo.registerMethod (name: "_mproxy_set_model", flags: .default, returnValue: nil, arguments: [_pmodel], function: Car._mproxy_set_model)
    	classInfo.registerProperty (_pmodel, getter: "_mproxy_get_model", setter: "_mproxy_set_model")
    } ()
    
}
""",
            macros: testMacros
        )
    }
    
    func testGodotExportGroupProducesVariantCollectionPropertiesWithPrefixes_whenAllPropertiesAppearAfterexportGroup() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    #exportGroup("Vehicle")
    @Export var makes: VariantCollection<String> = ["Mazda"]
    @Export var model: VariantCollection<String> = ["RX7"]
}
""",
   expandedSource:
"""

class Car: Node {
    var makes: VariantCollection<String> = ["Mazda"]

    func _mproxy_get_makes(args: [Variant]) -> Variant? {
    	return Variant(makes.array)
    }

    func _mproxy_set_makes(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(String.self)) else {
    		return nil
    	}
    	makes.array = gArray
    	return nil
    }
    var model: VariantCollection<String> = ["RX7"]

    func _mproxy_get_model(args: [Variant]) -> Variant? {
    	return Variant(model.array)
    }

    func _mproxy_set_model(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(String.self)) else {
    		return nil
    	}
    	model.array = gArray
    	return nil
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        classInfo.addPropertyGroup(name: "Vehicle", prefix: "")
        let _pmakes = PropInfo (
            propertyType: .array,
            propertyName: "makes",
            className: StringName("Array[String]"),
            hint: .arrayType,
            hintStr: "String",
            usage: .array)
    	classInfo.registerMethod (name: "get_makes", flags: .default, returnValue: _pmakes, arguments: [], function: Car._mproxy_get_makes)
    	classInfo.registerMethod (name: "set_makes", flags: .default, returnValue: nil, arguments: [_pmakes], function: Car._mproxy_set_makes)
    	classInfo.registerProperty (_pmakes, getter: "get_makes", setter: "set_makes")
        let _pmodel = PropInfo (
            propertyType: .array,
            propertyName: "model",
            className: StringName("Array[String]"),
            hint: .arrayType,
            hintStr: "String",
            usage: .array)
    	classInfo.registerMethod (name: "get_model", flags: .default, returnValue: _pmodel, arguments: [], function: Car._mproxy_get_model)
    	classInfo.registerMethod (name: "set_model", flags: .default, returnValue: nil, arguments: [_pmodel], function: Car._mproxy_set_model)
    	classInfo.registerProperty (_pmodel, getter: "get_model", setter: "set_model")
    } ()
}
""",
   macros: testMacros
        )
    }
    
    func testGodotExportGroupOnlyProducesVariantCollectionPropertiesWithPrefixes_whenPropertiesAppearAfterexportGroup() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    @Export var vins: VariantCollection<String> = ["00000000000000000"]
    #exportGroup("YMMS")
    @Export var years: VariantCollection<Int> = [1997]
}
""",
            expandedSource:
"""


class Car: Node {
    var vins: VariantCollection<String> = ["00000000000000000"]

    func _mproxy_get_vins(args: [Variant]) -> Variant? {
    	return Variant(vins.array)
    }

    func _mproxy_set_vins(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(String.self)) else {
    		return nil
    	}
    	vins.array = gArray
    	return nil
    }
    var years: VariantCollection<Int> = [1997]

    func _mproxy_get_years(args: [Variant]) -> Variant? {
    	return Variant(years.array)
    }

    func _mproxy_set_years(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Int.self)) else {
    		return nil
    	}
    	years.array = gArray
    	return nil
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        let _pvins = PropInfo (
            propertyType: .array,
            propertyName: "vins",
            className: StringName("Array[String]"),
            hint: .arrayType,
            hintStr: "String",
            usage: .array)
    	classInfo.registerMethod (name: "get_vins", flags: .default, returnValue: _pvins, arguments: [], function: Car._mproxy_get_vins)
    	classInfo.registerMethod (name: "set_vins", flags: .default, returnValue: nil, arguments: [_pvins], function: Car._mproxy_set_vins)
    	classInfo.registerProperty (_pvins, getter: "get_vins", setter: "set_vins")
        classInfo.addPropertyGroup(name: "YMMS", prefix: "")
        let _pyears = PropInfo (
            propertyType: .array,
            propertyName: "years",
            className: StringName("Array[int]"),
            hint: .arrayType,
            hintStr: "int",
            usage: .array)
    	classInfo.registerMethod (name: "get_years", flags: .default, returnValue: _pyears, arguments: [], function: Car._mproxy_get_years)
    	classInfo.registerMethod (name: "set_years", flags: .default, returnValue: nil, arguments: [_pyears], function: Car._mproxy_set_years)
    	classInfo.registerProperty (_pyears, getter: "get_years", setter: "set_years")
    } ()
}
""",
            macros: testMacros
        )
    }
    
    func testGodotExportGroupProducesVariantCollectionPropertiesWithoutPrefixes_whenAllPropertiesAppearAfterexportGroup() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    @Export var vins: VariantCollection<String> = ["00000000000000000"]
    @Export var years: VariantCollection<Int> = [1997]
    #exportGroup("Pointless")
}
""",
            expandedSource:
"""

class Car: Node {
    var vins: VariantCollection<String> = ["00000000000000000"]

    func _mproxy_get_vins(args: [Variant]) -> Variant? {
    	return Variant(vins.array)
    }

    func _mproxy_set_vins(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(String.self)) else {
    		return nil
    	}
    	vins.array = gArray
    	return nil
    }
    var years: VariantCollection<Int> = [1997]

    func _mproxy_get_years(args: [Variant]) -> Variant? {
    	return Variant(years.array)
    }

    func _mproxy_set_years(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Int.self)) else {
    		return nil
    	}
    	years.array = gArray
    	return nil
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        let _pvins = PropInfo (
            propertyType: .array,
            propertyName: "vins",
            className: StringName("Array[String]"),
            hint: .arrayType,
            hintStr: "String",
            usage: .array)
    	classInfo.registerMethod (name: "get_vins", flags: .default, returnValue: _pvins, arguments: [], function: Car._mproxy_get_vins)
    	classInfo.registerMethod (name: "set_vins", flags: .default, returnValue: nil, arguments: [_pvins], function: Car._mproxy_set_vins)
    	classInfo.registerProperty (_pvins, getter: "get_vins", setter: "set_vins")
        let _pyears = PropInfo (
            propertyType: .array,
            propertyName: "years",
            className: StringName("Array[int]"),
            hint: .arrayType,
            hintStr: "int",
            usage: .array)
    	classInfo.registerMethod (name: "get_years", flags: .default, returnValue: _pyears, arguments: [], function: Car._mproxy_get_years)
    	classInfo.registerMethod (name: "set_years", flags: .default, returnValue: nil, arguments: [_pyears], function: Car._mproxy_set_years)
    	classInfo.registerProperty (_pyears, getter: "get_years", setter: "set_years")
        classInfo.addPropertyGroup(name: "Pointless", prefix: "")
    } ()
}
""",
            macros: testMacros
        )
    }
    
    func testGodotExportGroupProducesVariantCollectionPropertiesWithDifferentPrefixes_whenPropertiesAppearAfterDifferentexportGroup() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    #exportGroup("VIN")
    @Export var vins: VariantCollection<String> = [""]
    #exportGroup("YMM")
    @Export var years: VariantCollection<Int> = [1997]
    @Export var makes: VariantCollection<String> = ["HONDA"]
    @Export var models: VariantCollection<String> = ["ACCORD"]
    
}
""",
            expandedSource:
"""

class Car: Node {
    var vins: VariantCollection<String> = [""]

    func _mproxy_get_vins(args: [Variant]) -> Variant? {
    	return Variant(vins.array)
    }

    func _mproxy_set_vins(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(String.self)) else {
    		return nil
    	}
    	vins.array = gArray
    	return nil
    }
    var years: VariantCollection<Int> = [1997]

    func _mproxy_get_years(args: [Variant]) -> Variant? {
    	return Variant(years.array)
    }

    func _mproxy_set_years(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Int.self)) else {
    		return nil
    	}
    	years.array = gArray
    	return nil
    }
    var makes: VariantCollection<String> = ["HONDA"]

    func _mproxy_get_makes(args: [Variant]) -> Variant? {
    	return Variant(makes.array)
    }

    func _mproxy_set_makes(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(String.self)) else {
    		return nil
    	}
    	makes.array = gArray
    	return nil
    }
    var models: VariantCollection<String> = ["ACCORD"]

    func _mproxy_get_models(args: [Variant]) -> Variant? {
    	return Variant(models.array)
    }

    func _mproxy_set_models(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(String.self)) else {
    		return nil
    	}
    	models.array = gArray
    	return nil
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        classInfo.addPropertyGroup(name: "VIN", prefix: "")
        let _pvins = PropInfo (
            propertyType: .array,
            propertyName: "vins",
            className: StringName("Array[String]"),
            hint: .arrayType,
            hintStr: "String",
            usage: .array)
    	classInfo.registerMethod (name: "get_vins", flags: .default, returnValue: _pvins, arguments: [], function: Car._mproxy_get_vins)
    	classInfo.registerMethod (name: "set_vins", flags: .default, returnValue: nil, arguments: [_pvins], function: Car._mproxy_set_vins)
    	classInfo.registerProperty (_pvins, getter: "get_vins", setter: "set_vins")
        classInfo.addPropertyGroup(name: "YMM", prefix: "")
        let _pyears = PropInfo (
            propertyType: .array,
            propertyName: "years",
            className: StringName("Array[int]"),
            hint: .arrayType,
            hintStr: "int",
            usage: .array)
    	classInfo.registerMethod (name: "get_years", flags: .default, returnValue: _pyears, arguments: [], function: Car._mproxy_get_years)
    	classInfo.registerMethod (name: "set_years", flags: .default, returnValue: nil, arguments: [_pyears], function: Car._mproxy_set_years)
    	classInfo.registerProperty (_pyears, getter: "get_years", setter: "set_years")
        let _pmakes = PropInfo (
            propertyType: .array,
            propertyName: "makes",
            className: StringName("Array[String]"),
            hint: .arrayType,
            hintStr: "String",
            usage: .array)
    	classInfo.registerMethod (name: "get_makes", flags: .default, returnValue: _pmakes, arguments: [], function: Car._mproxy_get_makes)
    	classInfo.registerMethod (name: "set_makes", flags: .default, returnValue: nil, arguments: [_pmakes], function: Car._mproxy_set_makes)
    	classInfo.registerProperty (_pmakes, getter: "get_makes", setter: "set_makes")
        let _pmodels = PropInfo (
            propertyType: .array,
            propertyName: "models",
            className: StringName("Array[String]"),
            hint: .arrayType,
            hintStr: "String",
            usage: .array)
    	classInfo.registerMethod (name: "get_models", flags: .default, returnValue: _pmodels, arguments: [], function: Car._mproxy_get_models)
    	classInfo.registerMethod (name: "set_models", flags: .default, returnValue: nil, arguments: [_pmodels], function: Car._mproxy_set_models)
    	classInfo.registerProperty (_pmodels, getter: "get_models", setter: "set_models")
    } ()
    
}
""",
            macros: testMacros
        )
    }
    
    // TODO: and ObjectCollection as well ...
    
    func testGodotExportGroupProducesObjectCollectionPropertiesWithPrefixes_whenAllPropertiesAppearAfterexportGroup() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    #exportGroup("Vehicle")
    @Export var makes: ObjectCollection<Node> = []
    @Export var model: ObjectCollection<Node> = []
}
""",
   expandedSource:
"""

class Car: Node {
    var makes: ObjectCollection<Node> = []

    func _mproxy_get_makes(args: [Variant]) -> Variant? {
    	return Variant(makes.array)
    }

    func _mproxy_set_makes(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Node.self)) else {
    		return nil
    	}
    	makes.array = gArray
    	return nil
    }
    var model: ObjectCollection<Node> = []

    func _mproxy_get_model(args: [Variant]) -> Variant? {
    	return Variant(model.array)
    }

    func _mproxy_set_model(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Node.self)) else {
    		return nil
    	}
    	model.array = gArray
    	return nil
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        classInfo.addPropertyGroup(name: "Vehicle", prefix: "")
        let _pmakes = PropInfo (
            propertyType: .array,
            propertyName: "makes",
            className: StringName("Array[Node]"),
            hint: .arrayType,
            hintStr: "Node",
            usage: .array)
    	classInfo.registerMethod (name: "get_makes", flags: .default, returnValue: _pmakes, arguments: [], function: Car._mproxy_get_makes)
    	classInfo.registerMethod (name: "set_makes", flags: .default, returnValue: nil, arguments: [_pmakes], function: Car._mproxy_set_makes)
    	classInfo.registerProperty (_pmakes, getter: "get_makes", setter: "set_makes")
        let _pmodel = PropInfo (
            propertyType: .array,
            propertyName: "model",
            className: StringName("Array[Node]"),
            hint: .arrayType,
            hintStr: "Node",
            usage: .array)
    	classInfo.registerMethod (name: "get_model", flags: .default, returnValue: _pmodel, arguments: [], function: Car._mproxy_get_model)
    	classInfo.registerMethod (name: "set_model", flags: .default, returnValue: nil, arguments: [_pmodel], function: Car._mproxy_set_model)
    	classInfo.registerProperty (_pmodel, getter: "get_model", setter: "set_model")
    } ()
}
""",
   macros: testMacros
        )
    }
    
    func testGodotExportGroupOnlyProducesObjectCollectionPropertiesWithPrefixes_whenPropertiesAppearAfterexportGroup() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    @Export var vins: ObjectCollection<Node> = []
    #exportGroup("YMMS")
    @Export var years: ObjectCollection<Node> = []
}
""",
            expandedSource:
"""

class Car: Node {
    var vins: ObjectCollection<Node> = []

    func _mproxy_get_vins(args: [Variant]) -> Variant? {
    	return Variant(vins.array)
    }

    func _mproxy_set_vins(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Node.self)) else {
    		return nil
    	}
    	vins.array = gArray
    	return nil
    }
    var years: ObjectCollection<Node> = []

    func _mproxy_get_years(args: [Variant]) -> Variant? {
    	return Variant(years.array)
    }

    func _mproxy_set_years(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Node.self)) else {
    		return nil
    	}
    	years.array = gArray
    	return nil
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        let _pvins = PropInfo (
            propertyType: .array,
            propertyName: "vins",
            className: StringName("Array[Node]"),
            hint: .arrayType,
            hintStr: "Node",
            usage: .array)
    	classInfo.registerMethod (name: "get_vins", flags: .default, returnValue: _pvins, arguments: [], function: Car._mproxy_get_vins)
    	classInfo.registerMethod (name: "set_vins", flags: .default, returnValue: nil, arguments: [_pvins], function: Car._mproxy_set_vins)
    	classInfo.registerProperty (_pvins, getter: "get_vins", setter: "set_vins")
        classInfo.addPropertyGroup(name: "YMMS", prefix: "")
        let _pyears = PropInfo (
            propertyType: .array,
            propertyName: "years",
            className: StringName("Array[Node]"),
            hint: .arrayType,
            hintStr: "Node",
            usage: .array)
    	classInfo.registerMethod (name: "get_years", flags: .default, returnValue: _pyears, arguments: [], function: Car._mproxy_get_years)
    	classInfo.registerMethod (name: "set_years", flags: .default, returnValue: nil, arguments: [_pyears], function: Car._mproxy_set_years)
    	classInfo.registerProperty (_pyears, getter: "get_years", setter: "set_years")
    } ()
}
""",
            macros: testMacros
        )
    }
    
    func testGodotExportGroupProducesObjectCollectionPropertiesWithoutPrefixes_whenAllPropertiesAppearAfterexportGroup() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    @Export var vins: ObjectCollection<Node> = []
    @Export var years: ObjectCollection<Node> = []
    #exportGroup("Pointless")
}
""",
            expandedSource:
"""

class Car: Node {
    var vins: ObjectCollection<Node> = []

    func _mproxy_get_vins(args: [Variant]) -> Variant? {
    	return Variant(vins.array)
    }

    func _mproxy_set_vins(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Node.self)) else {
    		return nil
    	}
    	vins.array = gArray
    	return nil
    }
    var years: ObjectCollection<Node> = []

    func _mproxy_get_years(args: [Variant]) -> Variant? {
    	return Variant(years.array)
    }

    func _mproxy_set_years(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Node.self)) else {
    		return nil
    	}
    	years.array = gArray
    	return nil
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        let _pvins = PropInfo (
            propertyType: .array,
            propertyName: "vins",
            className: StringName("Array[Node]"),
            hint: .arrayType,
            hintStr: "Node",
            usage: .array)
    	classInfo.registerMethod (name: "get_vins", flags: .default, returnValue: _pvins, arguments: [], function: Car._mproxy_get_vins)
    	classInfo.registerMethod (name: "set_vins", flags: .default, returnValue: nil, arguments: [_pvins], function: Car._mproxy_set_vins)
    	classInfo.registerProperty (_pvins, getter: "get_vins", setter: "set_vins")
        let _pyears = PropInfo (
            propertyType: .array,
            propertyName: "years",
            className: StringName("Array[Node]"),
            hint: .arrayType,
            hintStr: "Node",
            usage: .array)
    	classInfo.registerMethod (name: "get_years", flags: .default, returnValue: _pyears, arguments: [], function: Car._mproxy_get_years)
    	classInfo.registerMethod (name: "set_years", flags: .default, returnValue: nil, arguments: [_pyears], function: Car._mproxy_set_years)
    	classInfo.registerProperty (_pyears, getter: "get_years", setter: "set_years")
        classInfo.addPropertyGroup(name: "Pointless", prefix: "")
    } ()
}
""",
            macros: testMacros
        )
    }
    
    func testGodotExportGroupProducesObjectCollectionPropertiesWithDifferentPrefixes_whenPropertiesAppearAfterDifferentexportGroup() {
        assertMacroExpansion(
"""
@Godot
class Car: Node {
    #exportGroup("VIN")
    @Export var vins: ObjectCollection<Node> = []
    #exportGroup("YMM")
    @Export var years: ObjectCollection<Node> = []
    @Export var makes: ObjectCollection<Node> = []
    @Export var models: ObjectCollection<Node> = []
    
}
""",
            expandedSource:
"""

class Car: Node {
    var vins: ObjectCollection<Node> = []

    func _mproxy_get_vins(args: [Variant]) -> Variant? {
    	return Variant(vins.array)
    }

    func _mproxy_set_vins(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Node.self)) else {
    		return nil
    	}
    	vins.array = gArray
    	return nil
    }
    var years: ObjectCollection<Node> = []

    func _mproxy_get_years(args: [Variant]) -> Variant? {
    	return Variant(years.array)
    }

    func _mproxy_set_years(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Node.self)) else {
    		return nil
    	}
    	years.array = gArray
    	return nil
    }
    var makes: ObjectCollection<Node> = []

    func _mproxy_get_makes(args: [Variant]) -> Variant? {
    	return Variant(makes.array)
    }

    func _mproxy_set_makes(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Node.self)) else {
    		return nil
    	}
    	makes.array = gArray
    	return nil
    }
    var models: ObjectCollection<Node> = []

    func _mproxy_get_models(args: [Variant]) -> Variant? {
    	return Variant(models.array)
    }

    func _mproxy_set_models(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(Node.self)) else {
    		return nil
    	}
    	models.array = gArray
    	return nil
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Car")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Car> (name: className)
        classInfo.addPropertyGroup(name: "VIN", prefix: "")
        let _pvins = PropInfo (
            propertyType: .array,
            propertyName: "vins",
            className: StringName("Array[Node]"),
            hint: .arrayType,
            hintStr: "Node",
            usage: .array)
    	classInfo.registerMethod (name: "get_vins", flags: .default, returnValue: _pvins, arguments: [], function: Car._mproxy_get_vins)
    	classInfo.registerMethod (name: "set_vins", flags: .default, returnValue: nil, arguments: [_pvins], function: Car._mproxy_set_vins)
    	classInfo.registerProperty (_pvins, getter: "get_vins", setter: "set_vins")
        classInfo.addPropertyGroup(name: "YMM", prefix: "")
        let _pyears = PropInfo (
            propertyType: .array,
            propertyName: "years",
            className: StringName("Array[Node]"),
            hint: .arrayType,
            hintStr: "Node",
            usage: .array)
    	classInfo.registerMethod (name: "get_years", flags: .default, returnValue: _pyears, arguments: [], function: Car._mproxy_get_years)
    	classInfo.registerMethod (name: "set_years", flags: .default, returnValue: nil, arguments: [_pyears], function: Car._mproxy_set_years)
    	classInfo.registerProperty (_pyears, getter: "get_years", setter: "set_years")
        let _pmakes = PropInfo (
            propertyType: .array,
            propertyName: "makes",
            className: StringName("Array[Node]"),
            hint: .arrayType,
            hintStr: "Node",
            usage: .array)
    	classInfo.registerMethod (name: "get_makes", flags: .default, returnValue: _pmakes, arguments: [], function: Car._mproxy_get_makes)
    	classInfo.registerMethod (name: "set_makes", flags: .default, returnValue: nil, arguments: [_pmakes], function: Car._mproxy_set_makes)
    	classInfo.registerProperty (_pmakes, getter: "get_makes", setter: "set_makes")
        let _pmodels = PropInfo (
            propertyType: .array,
            propertyName: "models",
            className: StringName("Array[Node]"),
            hint: .arrayType,
            hintStr: "Node",
            usage: .array)
    	classInfo.registerMethod (name: "get_models", flags: .default, returnValue: _pmodels, arguments: [], function: Car._mproxy_get_models)
    	classInfo.registerMethod (name: "set_models", flags: .default, returnValue: nil, arguments: [_pmodels], function: Car._mproxy_set_models)
    	classInfo.registerProperty (_pmodels, getter: "get_models", setter: "set_models")
    } ()
    
}
""",
            macros: testMacros
        )
    }
    
    func testGodotExportGroupProducesPropertiesWithDifferentPrefixes_whenMixingVariantCollectionObjectCollectionAndNormalVariableProperties() {
        assertMacroExpansion(
"""
@Godot
class Garage: Node {
    #exportGroup("Front Page")
    @Export var name: String = ""
    @Export var rating: Float = 0.0
    #exportGroup("More Details")
    @Export var reviews: VariantCollection<String> = []
    @Export var checkIns: ObjectCollection<CheckIn> = []
    @Export var address: String = ""
    #exportGroup("Hours and Insurance")
    @Export var daysOfOperation: VariantCollection<String> = []
    @Export var hours: VariantCollection<String> = []
    @Export var insuranceProvidersAccepted: ObjectCollection<InsuranceProvider> = []
}
""",
            expandedSource:
"""

class Garage: Node {
    var name: String = ""

    func _mproxy_set_name (args: [Variant]) -> Variant? {
    	name = String (args [0])!
    	return nil
    }

    func _mproxy_get_name (args: [Variant]) -> Variant? {
        return Variant (name)
    }
    var rating: Float = 0.0

    func _mproxy_set_rating (args: [Variant]) -> Variant? {
    	rating = Float (args [0])!
    	return nil
    }

    func _mproxy_get_rating (args: [Variant]) -> Variant? {
        return Variant (rating)
    }
    var reviews: VariantCollection<String> = []

    func _mproxy_get_reviews(args: [Variant]) -> Variant? {
    	return Variant(reviews.array)
    }

    func _mproxy_set_reviews(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(String.self)) else {
    		return nil
    	}
    	reviews.array = gArray
    	return nil
    }
    var checkIns: ObjectCollection<CheckIn> = []

    func _mproxy_get_checkIns(args: [Variant]) -> Variant? {
    	return Variant(checkIns.array)
    }

    func _mproxy_set_checkIns(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(CheckIn.self)) else {
    		return nil
    	}
    	checkIns.array = gArray
    	return nil
    }
    var address: String = ""

    func _mproxy_set_address (args: [Variant]) -> Variant? {
    	address = String (args [0])!
    	return nil
    }

    func _mproxy_get_address (args: [Variant]) -> Variant? {
        return Variant (address)
    }
    var daysOfOperation: VariantCollection<String> = []

    func _mproxy_get_daysOfOperation(args: [Variant]) -> Variant? {
    	return Variant(daysOfOperation.array)
    }

    func _mproxy_set_daysOfOperation(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(String.self)) else {
    		return nil
    	}
    	daysOfOperation.array = gArray
    	return nil
    }
    var hours: VariantCollection<String> = []

    func _mproxy_get_hours(args: [Variant]) -> Variant? {
    	return Variant(hours.array)
    }

    func _mproxy_set_hours(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(String.self)) else {
    		return nil
    	}
    	hours.array = gArray
    	return nil
    }
    var insuranceProvidersAccepted: ObjectCollection<InsuranceProvider> = []

    func _mproxy_get_insuranceProvidersAccepted(args: [Variant]) -> Variant? {
    	return Variant(insuranceProvidersAccepted.array)
    }

    func _mproxy_set_insuranceProvidersAccepted(args: [Variant]) -> Variant? {
    	guard let arg = args.first,
    		  let gArray = GArray(arg),
    		  gArray.isTyped(),
    		  gArray.isSameTyped(array: GArray(InsuranceProvider.self)) else {
    		return nil
    	}
    	insuranceProvidersAccepted.array = gArray
    	return nil
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static var _initializeClass: Void = {
        let className = StringName("Garage")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<Garage> (name: className)
        classInfo.addPropertyGroup(name: "Front Page", prefix: "")
        let _pname = PropInfo (
            propertyType: .string,
            propertyName: "name",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_name", flags: .default, returnValue: _pname, arguments: [], function: Garage._mproxy_get_name)
    	classInfo.registerMethod (name: "_mproxy_set_name", flags: .default, returnValue: nil, arguments: [_pname], function: Garage._mproxy_set_name)
    	classInfo.registerProperty (_pname, getter: "_mproxy_get_name", setter: "_mproxy_set_name")
        let _prating = PropInfo (
            propertyType: .float,
            propertyName: "rating",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_rating", flags: .default, returnValue: _prating, arguments: [], function: Garage._mproxy_get_rating)
    	classInfo.registerMethod (name: "_mproxy_set_rating", flags: .default, returnValue: nil, arguments: [_prating], function: Garage._mproxy_set_rating)
    	classInfo.registerProperty (_prating, getter: "_mproxy_get_rating", setter: "_mproxy_set_rating")
        classInfo.addPropertyGroup(name: "More Details", prefix: "")
        let _previews = PropInfo (
            propertyType: .array,
            propertyName: "reviews",
            className: StringName("Array[String]"),
            hint: .arrayType,
            hintStr: "String",
            usage: .array)
    	classInfo.registerMethod (name: "get_reviews", flags: .default, returnValue: _previews, arguments: [], function: Garage._mproxy_get_reviews)
    	classInfo.registerMethod (name: "set_reviews", flags: .default, returnValue: nil, arguments: [_previews], function: Garage._mproxy_set_reviews)
    	classInfo.registerProperty (_previews, getter: "get_reviews", setter: "set_reviews")
        let _pcheckIns = PropInfo (
            propertyType: .array,
            propertyName: "check_ins",
            className: StringName("Array[CheckIn]"),
            hint: .arrayType,
            hintStr: "CheckIn",
            usage: .array)
    	classInfo.registerMethod (name: "get_check_ins", flags: .default, returnValue: _pcheckIns, arguments: [], function: Garage._mproxy_get_checkIns)
    	classInfo.registerMethod (name: "set_check_ins", flags: .default, returnValue: nil, arguments: [_pcheckIns], function: Garage._mproxy_set_checkIns)
    	classInfo.registerProperty (_pcheckIns, getter: "get_check_ins", setter: "set_check_ins")
        let _paddress = PropInfo (
            propertyType: .string,
            propertyName: "address",
            className: className,
            hint: .none,
            hintStr: "",
            usage: .default)
    	classInfo.registerMethod (name: "_mproxy_get_address", flags: .default, returnValue: _paddress, arguments: [], function: Garage._mproxy_get_address)
    	classInfo.registerMethod (name: "_mproxy_set_address", flags: .default, returnValue: nil, arguments: [_paddress], function: Garage._mproxy_set_address)
    	classInfo.registerProperty (_paddress, getter: "_mproxy_get_address", setter: "_mproxy_set_address")
        classInfo.addPropertyGroup(name: "Hours and Insurance", prefix: "")
        let _pdaysOfOperation = PropInfo (
            propertyType: .array,
            propertyName: "days_of_operation",
            className: StringName("Array[String]"),
            hint: .arrayType,
            hintStr: "String",
            usage: .array)
    	classInfo.registerMethod (name: "get_days_of_operation", flags: .default, returnValue: _pdaysOfOperation, arguments: [], function: Garage._mproxy_get_daysOfOperation)
    	classInfo.registerMethod (name: "set_days_of_operation", flags: .default, returnValue: nil, arguments: [_pdaysOfOperation], function: Garage._mproxy_set_daysOfOperation)
    	classInfo.registerProperty (_pdaysOfOperation, getter: "get_days_of_operation", setter: "set_days_of_operation")
        let _phours = PropInfo (
            propertyType: .array,
            propertyName: "hours",
            className: StringName("Array[String]"),
            hint: .arrayType,
            hintStr: "String",
            usage: .array)
    	classInfo.registerMethod (name: "get_hours", flags: .default, returnValue: _phours, arguments: [], function: Garage._mproxy_get_hours)
    	classInfo.registerMethod (name: "set_hours", flags: .default, returnValue: nil, arguments: [_phours], function: Garage._mproxy_set_hours)
    	classInfo.registerProperty (_phours, getter: "get_hours", setter: "set_hours")
        let _pinsuranceProvidersAccepted = PropInfo (
            propertyType: .array,
            propertyName: "insurance_providers_accepted",
            className: StringName("Array[InsuranceProvider]"),
            hint: .arrayType,
            hintStr: "InsuranceProvider",
            usage: .array)
    	classInfo.registerMethod (name: "get_insurance_providers_accepted", flags: .default, returnValue: _pinsuranceProvidersAccepted, arguments: [], function: Garage._mproxy_get_insuranceProvidersAccepted)
    	classInfo.registerMethod (name: "set_insurance_providers_accepted", flags: .default, returnValue: nil, arguments: [_pinsuranceProvidersAccepted], function: Garage._mproxy_set_insuranceProvidersAccepted)
    	classInfo.registerProperty (_pinsuranceProvidersAccepted, getter: "get_insurance_providers_accepted", setter: "set_insurance_providers_accepted")
    } ()
}
""",
            macros: testMacros
        )
    }
}
