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

	override function simplify(ctx:CMEvaluationContext) {
		var e = exponent.simplify(ctx);
		if(CMLib.isZero(e)) {
			return new CMIntegerNumber(1);
		}

		if(CMLib.isOne(e)) {
			return base;
		}

		return this;
	}

	override function getStringForNode() {
		return "^";
	}
}
