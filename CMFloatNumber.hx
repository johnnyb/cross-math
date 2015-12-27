@:expose class CMFloatNumber extends CMScalarNumber {
	var number:Float;

	public function new(a:Float) {
		number = a;
	}
	
	override function asFloatValue():Float {
		return number;
	}

	override function asIntValue():Int {
		return cast(number, Int);
	}

	override function getStringForNode():String {
		return "" + number;
	}
}
