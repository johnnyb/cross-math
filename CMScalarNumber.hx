@expose class CMScalarNumber extends CMNumber {
	public function asFloatValue():Float {
		return Math.NaN;
	}

	public function asIntValue():Int {
		return 0;
	}
}
