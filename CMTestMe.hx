@:expose class CMTestMe {
	static function main() {
		var ctx = new CMEvaluationContext();
		trace("Starting CM Test");
		var exp:CMExpression = new CMMultiplicationOperator([new CMFloatNumber(2), new CMFloatNumber(3), new CMVariable("x"), new CMMultiplicationOperator([new CMFloatNumber(4), new CMVariable("y"), new CMFloatNumber(5)])]);
		trace(exp.getStringForNodes());
		exp = exp.simplify(ctx);
		trace(exp.getStringForNodes());

		exp = new CMDifferentialOperator(exp, 1);
		trace(exp.getStringForNodes());
		exp = exp.symbolicEvaluate(ctx);
		trace(exp.getStringForNodes());

		exp = new CMDifferentialOperator(new CMMultiplicationOperator([new CMVariable("x"), new CMVariable("y")]), 1);
		exp = exp.symbolicEvaluate(ctx);
		trace(exp.getStringForNodes());

		exp = new CMDifferentialOperator(new CMExponentOperator(new CMVariable("x"), new CMVariable("y")), 1);
		exp = exp.symbolicEvaluate(ctx);
		trace(exp.getStringForNodes());

		trace(CMLib.basicParse("(* asdf (23 3) (asdf (asdf2 ff)) (aa) ())"));
		trace(CMLib.parse("(* 2 3)"));
		trace(CMLib.parseExpression("(* 2 3)").simplify(ctx));
		trace(CMLib.parseExpression("(diff (* x 6))").getStringForNodes());
		trace(CMLib.parseExpression("(diff (* x 6))").symbolicEvaluate(ctx).simplify(ctx).getStringForNodes());
	}
}
