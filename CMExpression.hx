@:expose class CMExpression extends CMNode {
	// All expression subnodes must be expressions.  This limits casting.
	public var expressionSubnodes(get,set):Array<CMExpression>;
	public function get_expressionSubnodes():Array<CMExpression> { 
		return cast subnodes;
	}
	public function set_expressionSubnodes(val:Array<CMExpression>):Array<CMExpression> {
		subnodes = cast val;
		return val;
	}

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
		return this.symbolicEvaluate(ctx).simplify(ctx);
	}

	public function getDifferential(ctx:CMEvaluationContext):CMExpression {
		return new CMDifferentialOperator(this, 1);
	}

	public function isConstantExpression():Bool {
		var termlist = this.getTerminals();
		for(term in termlist) {
			if(!Std.is(term, CMValue)) {
				return false;
			}
		}

		return true;
	}
}
