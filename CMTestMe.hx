@:expose class CMTestMe {
	static function main() {
		var no_opts = new Map<String, Dynamic>();
		trace("Starting CM Test");
		var exp = new CMMultiplicationOperator([new CMFloatNumber(2), new CMFloatNumber(3), new CMVariable("x"), new CMMultiplicationOperator([new CMFloatNumber(4), new CMVariable("y"), new CMFloatNumber(5)])]);
		trace(exp.getStringForNodes());
		trace(exp.simplify(no_opts).getStringForNodes());
	}
}
