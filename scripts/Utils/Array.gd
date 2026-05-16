class_name ArrayUtil

static func same(a: Array, b: Array) -> bool:
	if len(a) != len(b): return false
	for i in len(a):
		if a[i] != b[i]:
			return false
	return true
