@:expose class CMMultiplicationOperator extends CMExpression {
	public function new(operands:Array<CMNode>) {
		subnodes = operands;
	}

	override function simplify(ctx:CMEvaluationContext):CMExpression {
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
			if(CMLib.isZero(val)) { // Short-circuit
				return new CMIntegerNumber(0);
			}

			if(CMLib.isOne(val)) {
				// Skip
			} else {
				if(Std.is(val, CMScalarNumber)) {
					has_float_result = true;
					float_result = float_result * cast(val, CMScalarNumber).asFloatValue();
				} else {
					remaining.push(cast(val, CMExpression).simplify(ctx));
				}
			}
		}

		if(has_float_result) {
			remaining.push(new CMFloatNumber(float_result));
		}

		if(remaining.length == 0) {
			trace("WARNING: multiplication should not have zero operands");
			return new CMIntegerNumber(1); // FIXME - should probably have a class for 1 or at least integer
		}

		if(remaining.length == 1) {
			return cast(remaining[0], CMExpression);
		}

		return new CMMultiplicationOperator(remaining);
	}

	override function getStringForNode() {
		return "*";
	}

	override function getDifferential(ctx:CMEvaluationContext):CMExpression {
		// FIXME - gather similars into exponents
		var new_exp:CMExpression = null;
		if(subnodes.length == 0) {
			return new CMIntegerNumber(0);
		}
		if(subnodes.length == 1) {
			return cast(subnodes[0], CMExpression).getDifferential(ctx);
		}
		for(node in subnodes) {
			if(new_exp == null) {
				new_exp = cast(node, CMExpression);
			} else {
				var diff_node = cast(node, CMExpression).getDifferential(ctx);
				var diff_exp = new_exp.getDifferential(ctx);
				new_exp = new CMAdditionOperator([new CMMultiplicationOperator([new_exp, diff_node]), new CMMultiplicationOperator([diff_exp, node])]);
			}
		}

		return new_exp;
	}
}
