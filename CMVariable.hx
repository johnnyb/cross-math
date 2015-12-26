class CMVariable extends CMFunction {
	var variableName:String;
	public function new(n:String) {
		variableName = n;
	}

	override function getStringForNode():String {
		return variableName;
	}
}
