@:expose class CMMultiplicationOperator extends CMExpression {
	public function new(operands:Array<CMNode>) {
		subnodes = operands;
	}

	override function simplify(opts:Map<String,Dynamic>):CMExpression {
		// FIXME - should gracefully degrade 
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
			if(Std.is(val, CMNumber)) {
				has_float_result = true;
				float_result = float_result * cast(val, CMFloatNumber).asFloatValue();
			} else {
				remaining.push(cast(val, CMExpression).simplify(opts));
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

	override function getDifferential(opts:Map<String, Dynamic>):CMExpression {
		var new_exp:CMExpression = null;
		if(subnodes.length == 0) {
			return new CMIntegerNumber(0);
		}
		if(subnodes.length == 1) {
			return cast(subnodes[0], CMExpression).getDifferential(opts);
		}
		for(node in subnodes) {
			if(new_exp == null) {
				new_exp = cast(node, CMExpression);
			} else {
				var diff_node = cast(node, CMExpression).getDifferential(opts);
				var diff_exp = new_exp.getDifferential(opts);
				new_exp = new CMAdditionOperator([new CMMultiplicationOperator([new_exp, diff_node]), new CMMultiplicationOperator([diff_exp, node])]);
			}
		}

		return new_exp;
	}
}
