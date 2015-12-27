@:expose class CMNode {
	public var subnodes:Array<CMNode>;

	public function copy():CMNode {
		var cls = Type.getClass(this);
		var inst = Type.createEmptyInstance(cls);
		inst.subnodes = subnodes.copy();
		return cast(inst, CMNode);
	}

	public function duplicate():CMNode {
		return null;
	}

	public function getStringForNode():String {
		return null;
	}

	public function getStringForNodes() {
		if(subnodes == null) {
			return getStringForNode();
		} else {
			var strings:Array<String> = [];
			strings.push(getStringForNode());
			for(n in subnodes) {
				if(n == null) {
					strings.push("*ERROR*");
				} else {
					strings.push(n.getStringForNodes());
				}
			}

			return "(" + strings.join(" ") + ")";
		}
	}

	public function isTerminal():Bool {
		return false;
	}

	function getTerminalsInternal(termlist:Array<CMNode>) {
		if(this.isTerminal()) {
			termlist.push(this);
		} else {
			for(node in subnodes) {
				node.getTerminalsInternal(termlist);
			}
		}
	}

	public function getTerminals():Array<CMNode> {
		var terminals:Array<CMNode> = [];
		this.getTerminalsInternal(terminals);
		return terminals;
	}
}
