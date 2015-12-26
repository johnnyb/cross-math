class CMNode {
	var subnodes:Array<CMNode>;

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
				strings.push(n.getStringForNodes());
			}

			return "(" + strings.join(" ") + ")";
		}
	}
}
