@:expose class CMTestMe {
	static function main() {
		var no_opts = new Map<String, Dynamic>();
		trace("Starting CM Test");
		var exp:CMExpression = new CMMultiplicationOperator([new CMFloatNumber(2), new CMFloatNumber(3), new CMVariable("x"), new CMMultiplicationOperator([new CMFloatNumber(4), new CMVariable("y"), new CMFloatNumber(5)])]);
		trace(exp.getStringForNodes());
		trace(exp.simplify(no_opts).getStringForNodes());


		exp = new CMDifferentialOperator(exp, 1);
		trace(exp.getStringForNodes());
		exp = exp.symbolicEvaluate(no_opts);
		trace(exp.getStringForNodes());
	}
}
