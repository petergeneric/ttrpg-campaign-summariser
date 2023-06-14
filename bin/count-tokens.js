#!/usr/bin/env node
const { get_encoding, encoding_for_model } = require("@dqbd/tiktoken");
const { readFile } = require('fs/promises')

async function cat(path) {  
  return await readFile(path, 'utf8')
}

async function main(args) {
	if (args.length == 0 || args[0] == "--help") {
		console.log("Expected first argument to be file to read")
		return;
	}
	
	// Read input file
	const text = await cat(args[0]);

	// Count tokens
	const enc = encoding_for_model("gpt-3.5-turbo");
	try {
		console.log(enc.encode(text).length);
	} catch (e) {
		console.warn("Error counting tokens", e);
	} finally {
		enc.free();
	}
}

main(process.argv.slice(2));
