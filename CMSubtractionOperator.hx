@:expose class CMSubtractionOperator extends CMExpression {
	public function new(operands:Array<CMExpression>) {
		expressionSubnodes = operands;
	}

	override function getDifferential(ctx:CMEvaluationContext) {
		return new CMSubtractionOperator([for(node in subnodes) cast(node, CMExpression).getDifferential(ctx)]);
	}

	override function getStringForNode() {
		return "-";
	}

	override function simplify(ctx:CMEvaluationContext):CMExpression {
		var enodes = expressionSubnodes.copy();
		var base = enodes.pop();
		enodes = [for(node in enodes) new CMMultiplicationOperator([new CMIntegerNumber(-1), node])];
		enodes.unshift(base);
		var add = new CMAdditionOperator(enodes);
		return add.simplify(ctx);
	}
}
