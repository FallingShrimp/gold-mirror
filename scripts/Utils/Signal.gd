class_name SignalUtil

static func once(sig: Signal, executor: Callable):
	sig.connect(executor, Object.ConnectFlags.CONNECT_ONE_SHOT)
