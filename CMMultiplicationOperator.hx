@:expose class CMMultiplicationOperator extends CMExpression {
	public function new(operands:Array<CMExpression>) {
		expressionSubnodes = operands;
	}

	// FIXME - eventually reduce like things to each other
	static function combineConstants(lst:Array<CMExpression>, ctx:CMEvaluationContext) {
		if(lst.length == 1) {
			return lst[0];
		} else {
			return new CMMultiplicationOperator(lst);
		}
	}

	static function combineMultipliers(lst:Array<CMExpression>, newlst:Array<CMExpression>) {
		for(node in lst) {
			if(Std.is(node, CMMultiplicationOperator)) {
				combineMultipliers(node.expressionSubnodes, newlst);
			} else {
				newlst.push(node);
			}
		}
	}

	override function simplify(ctx:CMEvaluationContext):CMExpression {
		// Build from commutative property
		var operands:Array<CMExpression> = [];
		combineMultipliers(expressionSubnodes, operands);

		// Separate out constants and non-constants
		var constants:Array<CMExpression> = [];
		var non_constants:Array<CMExpression> = [];
		for(node in operands) {
			if(CMLib.isZero(node)) {
				return CMLib.zero; // Short-circuit
			}
			if(CMLib.isOne(node)) {
				// Do nothing - identity
			}
			if(node.isConstantExpression()) {
				constants.push(node);
			} else {
				non_constants.push(node);
			}
		}

		// Rebuild new value

		var new_operands:Array<CMExpression> = non_constants;
		if(constants.length > 0) {
			new_operands.unshift(combineConstants(constants, ctx));
		}

		if(new_operands.length == 0) {
			return CMLib.one;
		}

		if(new_operands.length == 1) {
			return new_operands[0];
		}

		return new CMMultiplicationOperator(new_operands);
	}

	override function getStringForNode() {
		return "*";
	}

	override function getDifferential(ctx:CMEvaluationContext):CMExpression {
		// FIXME - gather similars into exponents
		var new_exp:CMExpression = null;
		var elist = expressionSubnodes;
		if(elist.length == 0) {
			return CMLib.zero;
		}
		if(elist.length == 1) {
			return elist[0].getDifferential(ctx);
		}
		for(node in expressionSubnodes) {
			if(new_exp == null) {
				new_exp = node;
			} else {
				var diff_node = node.getDifferential(ctx);
				var diff_exp = new_exp.getDifferential(ctx);
				new_exp = new CMAdditionOperator([new CMMultiplicationOperator([new_exp, diff_node]), new CMMultiplicationOperator([diff_exp, node])]);
			}
		}

		return new_exp;
	}
}
