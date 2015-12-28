
enum EvaluationModeEnum {
	Exact;
	Numeric;
}

@:expose class CMEvaluationContext {
	public var recursiveSimplify:Bool;
	public var evaluationMode:EvaluationModeEnum;
	public function new() {
		recursiveSimplify = true;
	}
}
