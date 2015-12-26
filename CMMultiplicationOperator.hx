class CMMultiplicationOperator extends CMExpression {
	public function new(operands:Array<CMNode>) {
		subnodes = operands;
	}

	override function simplify(opts:Map<String,Dynamic>):CMExpression {
		var float_result = 1.0;
		var has_float_result = false;
		var remaining:Array<CMNode> = [];

		var operands:Array<CMNode> = [];

		for(val in subnodes) {
			if(Std.is(val, CMMultiplicationOperator)) {
				operands = operands.concat(val.subnodes);
			} else {
				operands.push(val);
			}
		}

		for(val in operands) {
			if(Std.is(val, CMFloatNumber)) {
				has_float_result = true;
				float_result = float_result * cast(val, CMFloatNumber).asFloatValue();
			} else {
				if(opts.get("recurse") == true) {
					remaining.push(cast(val, CMExpression).simplify(opts));
				} else {
					remaining.push(val);
				}
			}
		}

		if(has_float_result) {
			remaining.push(new CMFloatNumber(float_result));
		}

		if(remaining.length == 0) {
			return new CMFloatNumber(1.0); // FIXME - should probably have a class for 1 or at least integer
		}

		if(remaining.length == 1) {
			return cast(remaining[0], CMExpression);
		}

		return new CMMultiplicationOperator(remaining);
	}

	override function getStringForNode() {
		return "*";
	}
}
