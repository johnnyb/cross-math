@expose class CMExponentOperator extends CMExpression {
	public function new(base:CMExpression, exponent:CMExpression) {
		subnodes = [base, exponent];
	}

	override function getDifferential(opts:Map<String, Dynamic>) {
		var base = cast(subnodes[0], CMExpression);
		var exponent = cast(subnodes[1], CMExpression);
		return new CMAdditionOperator([
			new CMMultiplicationOperator([
				exponent,
				new CMExponentOperator(base, new CMAdditionOperator([exponent, new CMIntegerNumber(-1)])),
				base.getDifferential(opts)
			]),
			new CMMultiplicationOperator([
				this,
				new CMLogOperator(base),
				exponent.getDifferential(opts)
			])
		]);
	}

	override function getStringForNode() {
		return "^";
	}
}
