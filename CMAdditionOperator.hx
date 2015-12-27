@:expose class CMAdditionOperator extends CMExpression {
	public function new(operands:Array<CMNode>) {
		subnodes = operands;
	}

	override function getDifferential(ctx:CMEvaluationContext) {
		return new CMAdditionOperator([for(node in subnodes) cast(node, CMExpression).getDifferential(ctx)]);
	}
	override function getStringForNode() {
		return "+";
	}

	override function simplify(ctx:CMEvaluationContext):CMExpression {
		// FIXME - gather similars into multiplications

		var float_result = 0.0;
		var has_float_result = false;	

		var operands:Array<CMExpression> = [];
		var remaining:Array<CMExpression> = [];

		for(val in expressionSubnodes) {
			val = val.simplify(ctx);
			if(Std.is(val, CMAdditionOperator)) {
				operands = operands.concat(val.expressionSubnodes);
			} else {
				operands.push(val);
			}
		}

		for(val in operands) {
			if(CMLib.isZero(val)) {
				// Skip
			} else {
				if(Std.is(val, CMScalarNumber)) {
					has_float_result = true;
					float_result = float_result + cast(val, CMScalarNumber).asFloatValue();
				} else {
					remaining.push(val);
				}
			}
		}

		if(has_float_result) {
			remaining.push(new CMFloatNumber(float_result));
		}

		if(remaining.length == 0) {
			trace("WARNING: addition should not have zero operands");
			return new CMIntegerNumber(0);
		}

		if(remaining.length == 1) {
			return remaining[0];
		}

		var ary:Array<CMNode> = cast remaining;

		return new CMAdditionOperator(ary);
	}
}
