@:expose class CMValue extends CMExpression {
	override function getDifferential(ctx:CMEvaluationContext) {
		return new CMIntegerNumber(0);
	}

	override function isTerminal():Bool {
		return true;
	}
}
