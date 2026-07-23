// webhook-relay.js
const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');

const app = express();
const PORT = 61121; // was 5000

// Your actual Discord Webhook URL
const DISCORD_WEBHOOK_URL = 'https://discord.com/api/webhooks/1463164884765118616/S4LzVhvnjjcEIaoeKccxyvOXsnpgGlK-Vx8Iy1n1IEvIhVmCDGubLQHvA-NnVjTQYenZ';

app.use(bodyParser.json());

app.post('/ooc', async (req, res) => {
	const { username, message } = req.body;

	if (!username || !message) {
		return res.status(400).send("Missing username or message");
	}

	try {
		await axios.post(DISCORD_WEBHOOK_URL, {
			username: username,
			content: message
		});
		res.sendStatus(204); // Discord sends no body on success
	} catch (err) {
		console.error("Failed to send to Discord:", err);
		res.status(500).send("Discord error");
	}
});

app.listen(PORT, () => {
	console.log(`Webhook relay running on http://localhost:${61121}`);
});
