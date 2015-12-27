@:expose class CMIntegerNumber extends CMScalarNumber {
	var number:Int;

	public function new(a:Int) {
		number = a;
	}
	
	override function asFloatValue():Float {
		return number;
	}

	override function asIntValue():Int {
		return number;
	}

	override function getStringForNode():String {
		return "" + number;
	}
}
