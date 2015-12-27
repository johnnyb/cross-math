@:expose class CMLogOperator extends CMExpression {
	public function new(operand:CMExpression) {
		subnodes = [operand];
	}

	override function getDifferential(opts:Map<String, Dynamic>) {
		var expression = cast(subnodes[0], CMExpression);
		return new CMMultiplicationOperator([
			new CMExponentOperator(expression, new CMIntegerNumber(-1)),
			expression.getDifferential(opts)
		]);
	}

	override function getStringForNode() {
		return "ln";
	}	
}
