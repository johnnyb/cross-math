// This class is used to collect constants together into a single term to make manipulation easier.
//  This only has one subnode, which is some combination of constant expressions.
@:expose class CMCompositeValue extends CMValue {
	function new(val:CMExpression) {
		expressionSubnodes = [val];
	}

	override function isTerminal():Bool {
		return false;
	}
}
