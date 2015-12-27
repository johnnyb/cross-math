@expose class CMDifferentialOperator extends CMExpression {
	public var expression(get, set):CMExpression;
	public var level(get, set):Int;

	function get_expression():CMExpression {
		return cast(subnodes[0], CMExpression);
	}
	function set_expression(exp:CMExpression):CMExpression {
		subnodes[0] = exp;
		return exp;
	}

	function get_level():Int {
		return cast(subnodes[1], CMIntegerNumber).asIntValue();
	}

	function set_level(lvl:Int):Int {
		subnodes[1] = new CMIntegerNumber(lvl);
		return lvl;
	}

	public function new(diff_of:CMExpression, lvl:Int) {
		this.subnodes = [];
		this.expression = diff_of;
		this.level = lvl;
	}

	override function simplify(ctx:CMEvaluationContext):CMExpression {
		var simplified:CMExpression;
		if(Std.is(this.expression, CMDifferentialOperator)) {
			simplified = new CMDifferentialOperator(cast(this.expression.subnodes[0], CMExpression), this.level + 1);
		} else {
			if(ctx.recursiveSimplify) {
				var tmpdiff = cast(this.copy(), CMDifferentialOperator);
				tmpdiff.expression = tmpdiff.expression.simplify(ctx);
				simplified = tmpdiff;
			} else {
				simplified = this;
			}
		}

		return simplified;
	}

	override function symbolicEvaluate(ctx:CMEvaluationContext):CMExpression {
		if(Std.is(this.expression, CMVariable)) {
			return this;
		}
		var exp = this.expression;
		for(i in 0...(this.level)) {
			exp = getExpressionDifferential(exp, ctx);
		}
		return exp;
	}

	function getExpressionDifferential(expression:CMExpression, ctx:CMEvaluationContext):CMExpression {
		return expression.getDifferential(ctx);
	}

	override function getStringForNode() {
		return "diff";
	}
}
