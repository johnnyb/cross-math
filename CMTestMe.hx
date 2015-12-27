@:expose class CMTestMe {
	static function main() {
		var no_opts = new Map<String, Dynamic>();
		trace("Starting CM Test");
		var exp:CMExpression = new CMMultiplicationOperator([new CMFloatNumber(2), new CMFloatNumber(3), new CMVariable("x"), new CMMultiplicationOperator([new CMFloatNumber(4), new CMVariable("y"), new CMFloatNumber(5)])]);
		trace(exp.getStringForNodes());
		exp = exp.simplify(no_opts);
		trace(exp.getStringForNodes());

		exp = new CMDifferentialOperator(exp, 1);
		trace(exp.getStringForNodes());
		exp = exp.symbolicEvaluate(no_opts);
		trace(exp.getStringForNodes());

		exp = new CMDifferentialOperator(new CMMultiplicationOperator([new CMVariable("x"), new CMVariable("y")]), 1);
		exp = exp.symbolicEvaluate(no_opts);
		trace(exp.getStringForNodes());

		exp = new CMDifferentialOperator(new CMExponentOperator(new CMVariable("x"), new CMVariable("y")), 1);
		exp = exp.symbolicEvaluate(no_opts);
		trace(exp.getStringForNodes());
	}
}
