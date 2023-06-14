Caption To Episode Summary Helper Scripts
=========================================

This set of scripts pre-processes captions into input for submission to an LLM (targeting OpenAI GPT 3.5-Turbo 16K) to generate episode summaries of TTRPG Episodes.

To use it:


Install
-------

First, install the module dependencies:
```
cd bin
npm install
```

Configure
---------

Edit the bin/config.js file (see bin/config.js.example) to specify your OpenAI API Key



Break Episodes Up Into Chunks
-----------------------------
The first step is to take the full episode caption files from subtitle-src/ and generate a .txt file in the out/parts/ folder (one file per half-episode).
If you are using this to process a different show then you'll need to do some work to make sure that the token count of each half-episode file is somewhat below 16K tokens (the current limit for the largest generally-available OpenAI model at the time of writing).

```
./preprocess-episodes.sh
```


Run the episodes through the LLM
--------------------------------

The following will request summaries for each part, writing the output to `out/parts/summary/(episode).txt`, as well as `out/summary.txt` containing all the summaries in one file

```
./summarise-all.sh
```
