class CMAdditionOperator extends CMExpression {
	public function new(operands:Array<CMNode>) {
		subnodes = operands;
	}

	override function getDifferential(opts:Map<String, Dynamic>) {
		return new CMAdditionOperator([for(node in subnodes) cast(node, CMExpression).getDifferential(opts)]);
	}
}
