Caption To Episode Summary Helper Scripts
=========================================

This set of scripts pre-processes captions into input for submission to an LLM (targeting OpenAI GPT 3.5-Turbo 16K) to generate episode summaries of TTRPG campaigns.

Example Summaries
=================

You'll find some example transcriptions in the `example-summary` folder. These have been through some minor additional copy editing after LLM output:

- Time For Chaos - a playthrough of the first two chapters of Masks of Nyarlathotep. This summarisation cost around $3 in OpenAI requests
- Great Dane Society - summary of a full campaign of Masks of Nyarlathotep. this is substantial, coming in at 1.6 million words. The summarisation cost $5.80 in OpenAI requests.
 
Both of these summaries were produced from Youtube Automatic Captions


Generate Your Own
=================

Get Episode Text
----------------

You'll need to get the episode text. You may be lucky and have a high-quality transcription files already. If not, I recommend:

- Running the episode audio through [whisper](https://github.com/ggerganov/whisper.cpp)
- Downloading the YouTube Automatic Captions with a separate tool like yt-dlp

This repository contains an example of a long playthrough, the Quests and Chaos Masks of Nyarlathotep campaign, reproduced here with permission. See `example-campaign-texts/great-dane-society-masks-of-nyarlathotep/`, which should act as a good datasource to get started if you want to experiment with different modifications to the model.

Install Code Dependencies
-------

First, install the module dependencies:

```
cd bin
npm install
```

Configure
---------

Edit the bin/config.js file (see bin/config.js.example) to specify your OpenAI API Key. Note that you will be processing a lot of text as part of this work, so there will be charges from OpenAI (see example summary section above on how much it cost me)


Break Episodes Up Into Chunks
-----------------------------
The next step is to take the full episode caption files and split them up into parts. You can either do this manually and write files to the `out/parts/` folder, or you can try to use my example script (that's designed to work for playthroughs that use fixed language when going to break). If you are using this to process a different show then you'll need to do some work to make sure that the token count of each half-episode file is somewhat below 16K tokens (the current limit for the largest generally-available OpenAI model at the time of writing).

The following script provides an example of how to automatically split up episodes. This is often more work than it's worth, but can be useful for particularly large playthroughs.

```
./preprocess-episodes.sh
```

Clean up text
-------------

You can modify `filter.sh` to clean up the text. You'll find example filters in the `example-filters/` folder. The goal of these filters are to remove noise words and speech recognition mistakes. You may not need it if you're working from a high quality transcription.
Cleanup is important - it can improve the quality of the input to the model, but removing noise words, etc. can be key in getting the number of input tokens for the summarisation model down to 16K tokens.
You may also wish to do some manual cleanup of the text (e.g. to remove tangents that are not relevant to the gameplay)


Adjust your prompt
------------------

Adjust the prompt in `prompts/summarise.txt`
You'll also find an example of the prompt I used for the Time For Chaos playthrough in this folder

Run the episodes through the LLM
--------------------------------

The following will request summaries for each part, writing the output to `out/parts/summary/(episode).txt`, as well as `out/summary.txt` containing all the summaries in one file

```
./summarise-all.sh
```

