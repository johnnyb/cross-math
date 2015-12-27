@:expose class CMLib {
	public static var zero = new CMIntegerNumber(0);
	public static var one = new CMIntegerNumber(1);
	public static var negOne = new CMIntegerNumber(-1);
	public static var undefinedValue = new CMUndefinedValue();
	public static function isSpecificInteger(n:CMNode, i:Int) {
		if(Std.is(n, CMIntegerNumber)) {
			var num = cast(n, CMIntegerNumber);
			if(num.asIntValue() == i) {
				return true;
			}
		}

		return false;
	}
	public static function isZero(n:CMNode) {
		return isSpecificInteger(n, 0);
	}
	public static function isOne(n:CMNode) {
		return isSpecificInteger(n, 1);
	}

	public static function basicParse(str:String):Array<Dynamic> {
		var curpath:Array<Int> = [0];
		var expression = [];
		var curval = "";

		function setValue(val:Dynamic) {
			var pth:Array<Int> = curpath.copy();
			var exp = expression;
			var lastpart = pth.pop();
			for(idx in pth) {
				exp = cast(exp[idx], Array<Dynamic>);
			}
			exp[lastpart] = val;
		}

		function setval() {
			if(curval != "") {
				setValue(curval);
				curpath[curpath.length - 1] += 1;
				curval = "";
			}
		}

		for(chidx in 0...str.length) {
			var char = str.charAt(chidx);
			if(char == "(") {
				setValue([]);
				curpath.push(0);
			} else if (char == ")") {
				setval();
				curpath.pop();
				curpath[curpath.length - 1] += 1;
			} else if (char == " ") {
				setval();
			} else {
				curval = curval + char;
			}
		}

		return expression[0];
	}

	public static function parse(str:String):CMNode {
		var ary = basicParse(str);
		return interpret(ary);
	}

	public static function parseExpression(str:String):CMExpression {
		return cast(parse(str), CMExpression);
	}

	public static function interpret(val:Dynamic):CMNode {
		if(Std.is(val, Array)) {
			var ary = cast(val, Array<Dynamic>);
			ary = ary.copy();
			
			var otypes = allOperatorTypes();
			var funcname = ary.shift();
			var functype = otypes[funcname];
			if(functype == null) {
				trace("Error - unknown function: " + funcname);
				return null;
			}

			var inst:CMNode = cast(Type.createEmptyInstance(functype), CMNode);
			inst.subnodes = [for(x in ary) interpret(x)];
			return inst;
		} else {
			var str = cast(val, String);
			if(Math.isNaN(Std.parseFloat(str))) {
				return new CMVariable(str);
			} else {
				if(str.lastIndexOf(".") == -1) {
					return new CMIntegerNumber(Std.parseInt(str));
				} else {
					return new CMFloatNumber(Std.parseFloat(str));
				}
			}
		}
	}

	static var operatortypes:Map<String, Dynamic>;
	public static function allOperatorTypes():Map<String, Dynamic> {
		if(operatortypes == null) {
			var nodetypes:Array<Dynamic> = [
				CMAdditionOperator,
				CMDifferentialOperator,
				CMEquation,
				CMExponentOperator,
				CMLogOperator,
				CMSubtractionOperator,
				CMMultiplicationOperator,
				CMDivisionOperator
			];

			var otypes = new Map<String, Dynamic>();
			for(nodetype in nodetypes) {
				var n = Type.createEmptyInstance(nodetype);
				otypes[n.getStringForNode()] = nodetype;
			}
			
			operatortypes = otypes;	
		}

		return operatortypes;
	}

	public static function symbolicEvaluate(str:String):CMExpression {
		var ctx = new CMEvaluationContext();
		return CMLib.parseExpression(str).symbolicEvaluate(ctx).simplify(ctx);
	}
}
