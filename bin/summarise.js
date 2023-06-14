#!/usr/bin/env node

const {Configuration, OpenAIApi} = require("openai");
const { readFile } = require('fs/promises');

var config = require('./config.js');

const openai = new OpenAIApi(new Configuration({
    apiKey: config.openai.api_key,
}));


async function cat(path) {  
  return readFile(path, 'utf8')
}


async function generateSummary(instructionFile, textFile) {

	// Optionally, fill this with a series of replacer functions to run against OpenAI model output
    const replacements = new Array();

	// Generate the prompt
	const systemMessage = await cat(instructionFile);
	const promptText = await cat(textFile);


	// Make the request to OpenAI
    let completion;
    try {
        completion = await openai.createChatCompletion({
            model: config.openai.model,
            messages: [
             {role: "system", content: systemMessage},
             {role: "user", content: promptText},
            ]
        });
    } catch (e) {
        console.log("Error invoking OpenAI Chat Completion API", {e});

        return null;
    }

    const mainResponse = completion.data.choices[0];
    let usage = completion.data.usage;
    let rawAssistantMessage = mainResponse.message.content;
	    
    let warning = null;


	try {
		if (mainResponse.finish_reason !== 'stop') {
			if (mainResponse.finish_reason === 'content_filter') {
				throw new Error('OpenAI Content Filter stopped response');
			} else if (mainResponse.finish_reason === 'length') {
				throw new Error('Model output truncated (reached max output tokens)');
			} else {
				throw new Error('Unexpected OpenAI finish reason: ' + mainResponse.finish_reason);
			}
		}
    }
    catch(e) {
    	// Log partial model output (if any) and rethrow
    	console.warn("Partial Response Received: ", rawAssistantMessage);
    	throw e;
    }

    // Now apply post-processing to the response
    let assistantResponse = rawAssistantMessage;
    for (const replacer of replacements) {
        assistantResponse = replacer(assistantResponse);
    }

	console.log(assistantResponse);

	console.log("-- model " + completion.data.model + ", tokens in " + usage.prompt_tokens + ", out " + usage.completion_tokens + ", total " + usage.total_tokens + "");
}

async function main(args) {
	if (args.length == 0 || args[0] == "--help") {
		console.log("Expected first argument to be file to read")
		return;
	}
	
	generateSummary("prompts/summarise.txt", args[0]);
}

main(process.argv.slice(2));

