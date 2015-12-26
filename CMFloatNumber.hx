@:expose class CMFloatNumber extends CMNumber {
	var number:Float;

	public function new(a:Float) {
		number = a;
	}
	
	public function asFloatValue():Float {
		return number;
	}

	override function getStringForNode():String {
		return "" + number;
	}
}
