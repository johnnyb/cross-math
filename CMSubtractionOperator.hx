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
		var enodes = [for(node in subnodes.copy()) cast(node, CMExpression).simplify(ctx)];
		var base = enodes.pop();

		enodes = enodes.filter(function(node){return !CMLib.isSpecificInteger(node, 0);});
		enodes = [for(node in enodes) new CMMultiplicationOperator([new CMIntegerNumber(-1), node])];
		if(enodes.length > 0) {
			enodes.unshift(base);
			var add = new CMAdditionOperator(enodes);
			return add.simplify(ctx);
		} else {
			return base;
		}
	}
}
