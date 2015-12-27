@:expose class CMNode {
	public var subnodes:Array<CMNode>;

	public function copy():CMNode {
		var newnode = Reflect.copy(this);
		newnode.subnodes = newnode.subnodes.copy();
		return newnode;
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
}
