@:expose class CMExpression extends CMNode {
	public function simplify(opts:Map<String,Dynamic>):CMExpression {
		return this;
	}
	public function numericEvaluate(opts:Map<String,Dynamic>):CMExpression {
		return null;
	}
	public function symbolicEvaluate(opts:Map<String,Dynamic>):CMExpression {
		var copy = this.copy();
		copy.subnodes = [for(node in copy.subnodes) cast(node, CMExpression).symbolicEvaluate(opts)];
		return cast(copy, CMExpression);
	}
	public function exactEvaluate(opts:Map<String,Dynamic>):CMExpression {
		return null;
	}

	public function getDifferential(opts:Map<String,Dynamic>):CMExpression {
		return new CMDifferentialOperator(this, 1);
	}
}
