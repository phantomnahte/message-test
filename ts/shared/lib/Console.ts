class Console {
	log(...args: unknown[]) {
		print(...args);
	}

	error(...args: unknown[]) {
		print("Error:", ...args);
	}

	warn(...args: unknown[]) {
		print("Warning:", ...args);
	}
}

export { Console };
