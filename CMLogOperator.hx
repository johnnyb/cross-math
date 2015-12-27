@:expose class CMLogOperator extends CMExpression {
	public function new(operand:CMExpression) {
		subnodes = [operand];
	}

	override function getDifferential(ctx:CMEvaluationContext) {
		var expression = cast(subnodes[0], CMExpression);
		return new CMMultiplicationOperator([
			new CMExponentOperator(expression, new CMIntegerNumber(-1)),
			expression.getDifferential(ctx)
		]);
	}

	override function getStringForNode() {
		return "ln";
	}	
}
