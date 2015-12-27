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
}
