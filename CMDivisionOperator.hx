@:expose class CMDivisionOperator extends CMExpression {
	public function new(operands:Array<CMExpression>) {
		expressionSubnodes = operands;
	}

	function getAsMultiplicationOperation():CMExpression {
		var operands = expressionSubnodes.copy();
		var first = operands.shift();
		operands = [for(node in operands) new CMExponentOperator(node, CMLib.negOne)];
		operands.unshift(first);
		return new CMMultiplicationOperator(operands);
	}

	override function getDifferential(ctx:CMEvaluationContext) {
		return getAsMultiplicationOperation().getDifferential(ctx);
	}

	override function simplify(ctx:CMEvaluationContext):CMExpression {
		var operands = expressionSubnodes.copy();
		var first = operands.shift();
		first = first.simplify(ctx);
		operands = [for(node in operands) node.simplify(ctx)].filter(function(node){return !CMLib.isSpecificInteger(node, 1);});

		var zeroes = operands.filter(function(node){return CMLib.isSpecificInteger(node, 0);});
		if(zeroes.length > 0) {
			return CMLib.undefinedValue;
		}

		if(CMLib.isSpecificInteger(first, 0)) {
			return CMLib.zero;
		}

		if(operands.length == 0) {
			return first;
		}

		operands.unshift(first);
		return new CMDivisionOperator(operands);
	}

	override function getStringForNode():String {
		return "/";
	}
}
