@:expose class CMExpression extends CMNode {
	public function simplify(opts:Map<String,Dynamic>):CMExpression {
		return this;
	}
}
