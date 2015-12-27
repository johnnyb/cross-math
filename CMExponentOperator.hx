@expose class CMExponentOperator extends CMExpression {
	public function new(base:CMExpression, exponent:CMExpression) {
		subnodes = [base, exponent];
	}

	override function getDifferential(ctx:CMEvaluationContext) {
		var base = cast(subnodes[0], CMExpression);
		var exponent = cast(subnodes[1], CMExpression);
		return new CMAdditionOperator([
			new CMMultiplicationOperator([
				exponent,
				new CMExponentOperator(base, new CMAdditionOperator([exponent, new CMIntegerNumber(-1)])),
				base.getDifferential(ctx)
			]),
			new CMMultiplicationOperator([
				this,
				new CMLogOperator(base),
				exponent.getDifferential(ctx)
			])
		]);
	}

	override function getStringForNode() {
		return "^";
	}
}
