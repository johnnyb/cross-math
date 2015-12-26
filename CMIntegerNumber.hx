@:expose class CMIntegerNumber extends CMNumber {
	var number:Int;

	public function new(a:Int) {
		number = a;
	}
	
	public function asFloatValue():Float {
		return number;
	}

	override function getStringForNode():String {
		return "" + number;
	}
}
