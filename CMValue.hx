@:expose class CMValue extends CMExpression {
	override function getDifferential(opts:Map<String, Dynamic>) {
		return new CMIntegerNumber(0);
	}
}
