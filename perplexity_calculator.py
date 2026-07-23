import sys
from transformers import GPT2LMHeadModel, GPT2TokenizerFast
import torch

def calculate_perplexity(text):
	model = GPT2LMHeadModel.from_pretrained('gpt2')
	tokenizer = GPT2TokenizerFast.from_pretrained('gpt2')

	encodings = tokenizer(text, return_tensors='pt')
	with torch.no_grad():
		outputs = model(**encodings, labels=encodings['input_ids'])
		loss = outputs.loss
	perplexity = torch.exp(loss)
	return perplexity.item()

if __name__ == "__main__":
	if len(sys.argv) < 3:
		print("Usage: python perplexity_calculator.py input.txt output.txt")
		sys.exit(1)

	with open(sys.argv[1], "r") as infile:
		text = infile.read()

	perplexity = calculate_perplexity(text)

	with open(sys.argv[2], "w") as outfile:
		outfile.write(str(perplexity))
