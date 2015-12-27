@:expose class CMExpression extends CMNode {
	public function simplify(ctx:CMEvaluationContext):CMExpression {
		return this;
	}
	public function numericEvaluate(ctx:CMEvaluationContext):CMExpression {
		return null;
	}
	public function symbolicEvaluate(ctx:CMEvaluationContext):CMExpression {
		var copy = this.copy();
		copy.subnodes = [for(node in copy.subnodes) cast(node, CMExpression).symbolicEvaluate(ctx)];
		return cast(copy, CMExpression);
	}
	public function exactEvaluate(ctx:CMEvaluationContext):CMExpression {
		return null;
	}

	public function getDifferential(ctx:CMEvaluationContext):CMExpression {
		return new CMDifferentialOperator(this, 1);
	}
}
