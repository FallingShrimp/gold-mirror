class_name PresetSoftware

static func openssl(input: String, key: String, output: String):
	await TerminalManager.simulateCommand("openssl pkeyutl -decrypt -in %s -inkey %s -out %s" % [input, key, output])
	await TimeUtil.millseconds(500)
	await TerminalManager.progress(20)
	await TerminalManager.writeLine("\nDecryption successful. Output: %s" % output, 10, 2)
